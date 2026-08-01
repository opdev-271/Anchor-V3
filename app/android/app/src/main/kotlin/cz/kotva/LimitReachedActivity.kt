package cz.kotva

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.widget.Button
import android.widget.GridLayout
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import kotlin.random.Random

/**
 * Obrazovka po vyčerpání denního limitu aplikace.
 *
 * Chování se řídí zvolenou intenzitou ([LimitIntensity]):
 *
 *  - [LimitIntensity.ASK] — nabídne prodloužení o 5 minut; po jejich uplynutí
 *    se objeví znovu.
 *  - [LimitIntensity.CODE] — prodloužení navíc vyžaduje opsat kód na
 *    **přeházené** klávesnici. Smysl není v obtížnosti, ale v tom, že úkon
 *    nejde provést ze svalové paměti — vyžaduje pozornost, což je přesně to,
 *    co impulz přeruší.
 *  - [LimitIntensity.HARD] — bez prodloužení, do konce dne zavřeno.
 *
 * I u nejpřísnější intenzity se aplikace nesnaží uživateli zabránit v tom, aby
 * limit zrušil v nastavení Kotvy. Bariéra je pro impulz, ne pro rozhodnutí
 * (docs/spec.md §11).
 */
class LimitReachedActivity : Activity() {

    private lateinit var packageNameArg: String
    private var intensity = LimitIntensity.ASK

    private var code = ""
    private var entered = ""

    private lateinit var entryView: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_limit)

        packageNameArg = intent.getStringExtra(EXTRA_PACKAGE).orEmpty()
        intensity = LimitIntensity.fromIndex(intent.getIntExtra(EXTRA_INTENSITY, 0))
        val label = intent.getStringExtra(EXTRA_LABEL).orEmpty()
        val limitMinutes = intent.getIntExtra(EXTRA_LIMIT_MINUTES, 0)
        val usedMinutes = intent.getIntExtra(EXTRA_USED_MINUTES, 0)

        findViewById<TextView>(R.id.limit_detail).text = buildDetail(
            label = label,
            limitMinutes = limitMinutes,
            usedMinutes = usedMinutes,
        )

        entryView = findViewById(R.id.limit_code_entry)

        findViewById<Button>(R.id.limit_close).setOnClickListener { goHome() }

        val extendButton = findViewById<Button>(R.id.limit_extend)
        when (intensity) {
            LimitIntensity.HARD -> extendButton.visibility = View.GONE
            LimitIntensity.ASK -> extendButton.setOnClickListener { grantAndLeave() }
            LimitIntensity.CODE -> extendButton.setOnClickListener { showCodeChallenge() }
        }
    }

    private fun buildDetail(label: String, limitMinutes: Int, usedMinutes: Int): String {
        val name = label.ifBlank { packageNameArg }
        val base = "Dnes jsi v aplikaci $name strávil/a $usedMinutes z $limitMinutes minut."
        val extensions = AppLimits.extensionCountToday(this, packageNameArg)
        val tail = when {
            intensity == LimitIntensity.HARD -> " Pro dnešek to je vše."
            extensions > 0 -> " Dnes už jsi prodlužoval/a ${extensions}×."
            else -> ""
        }
        return base + tail
    }

    private fun showCodeChallenge() {
        findViewById<View>(R.id.limit_code_section).visibility = View.VISIBLE
        findViewById<Button>(R.id.limit_extend).visibility = View.GONE

        code = (1..4).map { Random.nextInt(0, 10) }.joinToString("")
        entered = ""
        findViewById<TextView>(R.id.limit_code_value).text = code
        entryView.text = ""

        buildScrambledKeypad()
    }

    /**
     * Klávesnice s číslicemi v náhodném pořadí. Pořadí se losuje při každém
     * zobrazení, takže si ho nelze zapamatovat.
     */
    private fun buildScrambledKeypad() {
        val grid = findViewById<GridLayout>(R.id.limit_keypad)
        grid.removeAllViews()

        val digits = (0..9).shuffled()
        for (digit in digits) {
            val button = Button(this).apply {
                text = digit.toString()
                textSize = 20f
                minWidth = 0
                minimumWidth = 0
                setOnClickListener { onDigit(digit) }
            }
            val params = GridLayout.LayoutParams().apply {
                width = dp(56)
                height = dp(56)
                setMargins(dp(4), dp(4), dp(4), dp(4))
                setGravity(Gravity.CENTER)
            }
            grid.addView(button, params)
        }

        val clear = Button(this).apply {
            text = "⌫"
            textSize = 18f
            setOnClickListener {
                entered = entered.dropLast(1)
                entryView.text = entered
            }
        }
        grid.addView(
            clear,
            GridLayout.LayoutParams().apply {
                width = LinearLayout.LayoutParams.WRAP_CONTENT
                height = dp(56)
                columnSpec = GridLayout.spec(0, 5)
                setMargins(dp(4), dp(4), dp(4), dp(4))
                setGravity(Gravity.CENTER)
            },
        )
    }

    private fun onDigit(digit: Int) {
        if (entered.length >= code.length) return
        entered += digit.toString()
        entryView.text = entered

        if (entered.length < code.length) return
        if (entered == code) {
            grantAndLeave()
        } else {
            Toast.makeText(this, R.string.limit_code_wrong, Toast.LENGTH_SHORT).show()
            // Nový kód i nové rozložení — opakovaný pokus nesmí být snazší.
            showCodeChallenge()
        }
    }

    private fun grantAndLeave() {
        AppLimits.grantExtension(this, packageNameArg)
        // Po dobu prodloužení má aplikace fungovat normálně, tedy i s
        // notifikacemi — jinak by uživatel nechápal, proč mu nic nechodí.
        NotificationSuppressor.release(this, packageNameArg)
        // Návrat do aplikace nechává na uživateli; jen zmizíme z cesty.
        finish()
    }

    private fun goHome() {
        startActivity(
            Intent(Intent.ACTION_MAIN).apply {
                addCategory(Intent.CATEGORY_HOME)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            },
        )
        finish()
    }

    @Deprecated("Nahrazeno predictive back; ponecháno kvůli minSdk 29.")
    @Suppress("DEPRECATION")
    override fun onBackPressed() {
        goHome()
    }

    private fun dp(value: Int): Int =
        (value * resources.displayMetrics.density).toInt()

    companion object {
        const val EXTRA_PACKAGE = "package"
        const val EXTRA_LABEL = "label"
        const val EXTRA_INTENSITY = "intensity"
        const val EXTRA_LIMIT_MINUTES = "limit_minutes"
        const val EXTRA_USED_MINUTES = "used_minutes"
    }
}
