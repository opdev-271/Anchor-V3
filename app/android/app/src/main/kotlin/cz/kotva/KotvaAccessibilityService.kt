package cz.kotva

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent

/**
 * Vynucuje blokaci aplikací během fokus session (docs/spec.md §5.2).
 *
 * Jak to funguje: služba dostává událost pokaždé, když se změní aktivní okno.
 * Pokud je právě blok aktivní a do popředí se dostane blokovaná aplikace,
 * překryje ji [ShieldActivity].
 *
 * ## Limity, které tahle cesta má (a nejde je obejít)
 *
 *  - **Nelze cizí aplikaci ukončit.** Android to běžné aplikaci neumožňuje.
 *    Blokace je tedy překryv a odklonění, ne "zabití" — uživatel může appku
 *    nechat běžet na pozadí. Pro účel appky to stačí: cílem je přerušit
 *    impulz, ne postavit vězení (§11).
 *  - **Uživatel může službu kdykoliv vypnout** v systémovém nastavení.
 *    To je záměr Androidu a je to v souladu s §11 — autonomie zůstává u něj.
 *  - **Událost dorazí až po otevření aplikace**, takže na zlomek vteřiny
 *    blokovanou aplikaci uvidí. Nelze předběhnout, systém dřív neinformuje.
 *  - **Nepokrývá weby.** Blokace konkrétních URL by znamenala číst obsah
 *    prohlížeče, což je disproporční zásah do soukromí a v rozporu s §9.
 *    Blokovat lze celý prohlížeč jako aplikaci; blokace jednotlivých webů
 *    v MVP schválně není.
 *
 * Alternativa `DevicePolicyManager.setPackagesSuspended` by uměla tvrdší
 * blokaci, ale vyžaduje roli device ownera — tu lze nastavit jen přes ADB nebo
 * podnikový enrollment na továrně resetovaném zařízení. Pro běžně distribuovanou
 * aplikaci není použitelná.
 */
class KotvaAccessibilityService : AccessibilityService() {

    /** Poslední zastíněný balíček — brání smyčce překryvů u téže aplikace. */
    private var lastShielded: String? = null
    private var lastShieldAt: Long = 0

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return

        // Vlastní appku ani systémové UI nikdy neblokujeme — jinak by se
        // uživatel nedostal ani do nastavení, ani do Kotvy samotné.
        if (packageName == applicationContext.packageName) return
        if (packageName == "com.android.systemui") return

        if (!BlockingState.isActive(this)) {
            lastShielded = null
            return
        }
        if (packageName !in BlockingState.blockedPackages(this)) return

        val now = System.currentTimeMillis()
        if (packageName == lastShielded && now - lastShieldAt < SHIELD_DEBOUNCE_MS) return

        lastShielded = packageName
        lastShieldAt = now
        showShield()
    }

    private fun showShield() {
        val intent = Intent(this, ShieldActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TASK or
                    Intent.FLAG_ACTIVITY_NO_ANIMATION,
            )
            putExtra(ShieldActivity.EXTRA_GOAL, BlockingState.goalText(this@KotvaAccessibilityService))
            putExtra(ShieldActivity.EXTRA_ENDS_AT, BlockingState.endsAt(this@KotvaAccessibilityService))
        }
        startActivity(intent)
    }

    override fun onInterrupt() = Unit

    private companion object {
        /**
         * Aplikace při startu vygeneruje víc window-state událostí za sebou.
         * Bez tlumení by se shield spustil několikrát a blikal.
         */
        const val SHIELD_DEBOUNCE_MS = 1500L
    }
}
