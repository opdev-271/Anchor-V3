package cz.kotva

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.Button
import android.widget.TextView

/**
 * Překryv zobrazený místo blokované aplikace během fokus session.
 *
 * Je to **nativní** Activity, ne Flutter route: musí naskočit okamžitě, i když
 * je Flutter engine uspaný. Načítání enginu by způsobilo prodlevu, během které
 * by uživatel koukal na blokovanou aplikaci.
 */
class ShieldActivity : Activity() {

    private val handler = Handler(Looper.getMainLooper())
    private var endsAt: Long = 0L
    private lateinit var remainingView: TextView

    private val tick = object : Runnable {
        override fun run() {
            val remaining = endsAt - System.currentTimeMillis()
            if (remaining <= 0) {
                // Blok mezitím doběhl — překryv nemá důvod dál stát v cestě.
                finish()
                return
            }
            remainingView.text = formatRemaining(remaining)
            handler.postDelayed(this, 1000)
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_shield)

        endsAt = intent.getLongExtra(EXTRA_ENDS_AT, 0L)
        remainingView = findViewById(R.id.shield_remaining)

        val goal = intent.getStringExtra(EXTRA_GOAL).orEmpty()
        if (goal.isNotBlank()) {
            findViewById<TextView>(R.id.shield_goal).apply {
                text = goal
                visibility = android.view.View.VISIBLE
            }
        }

        findViewById<Button>(R.id.shield_back).setOnClickListener { goHome() }
        findViewById<Button>(R.id.shield_open_kotva).setOnClickListener { openKotva() }
    }

    override fun onResume() {
        super.onResume()
        handler.post(tick)
    }

    override fun onPause() {
        super.onPause()
        handler.removeCallbacks(tick)
    }

    /**
     * Systémové "zpět" nesmí vrátit uživatele do blokované aplikace pod
     * překryvem — místo toho ho pošle na plochu.
     */
    @Deprecated("Nahrazeno predictive back; ponecháno kvůli minSdk 29.")
    @Suppress("DEPRECATION")
    override fun onBackPressed() {
        goHome()
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

    private fun openKotva() {
        packageManager.getLaunchIntentForPackage(packageName)?.let {
            it.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            startActivity(it)
        }
        finish()
    }

    private fun formatRemaining(millis: Long): String {
        val totalSeconds = millis / 1000
        val hours = totalSeconds / 3600
        val minutes = (totalSeconds % 3600) / 60
        val seconds = totalSeconds % 60
        return if (hours > 0) {
            String.format("%d:%02d:%02d", hours, minutes, seconds)
        } else {
            String.format("%02d:%02d", minutes, seconds)
        }
    }

    companion object {
        const val EXTRA_GOAL = "goal"
        const val EXTRA_ENDS_AT = "ends_at"
    }
}
