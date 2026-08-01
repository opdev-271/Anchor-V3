package cz.kotva

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityEvent

/**
 * Vynucuje blokaci aplikací během fokus session (docs/spec.md §5.2) a denní
 * limity aplikací (Anchor-V1 revize).
 *
 * Jak to funguje: služba dostává událost pokaždé, když se změní aktivní okno.
 * Podle toho, která aplikace je v popředí, buď nedělá nic, nebo ji překryje
 * [ShieldActivity] (fokus blok) či [LimitReachedActivity] (vyčerpaný limit).
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

    private val handler = Handler(Looper.getMainLooper())

    /**
     * Limit může doběhnout uprostřed používání, ne jen při otevření aplikace.
     * Bez opakované kontroly by šel obejít tím, že uživatel prostě nepřepne okno.
     *
     * Hlídka si popředí zjišťuje sama z [UsageTracker]. Dřívější verze si ho
     * pamatovala z událostí přístupnosti a ukázalo se to jako křehké: jakákoliv
     * událost z jiného balíčku hlídku odzbrojila a limit se pak během používání
     * nevynutil vůbec. Tahle verze běží nezávisle na tom, co za události chodí.
     */
    private val limitWatchdog = object : Runnable {
        override fun run() {
            val pkg = UsageTracker.currentForegroundPackage(
                this@KotvaAccessibilityService,
            )
            if (pkg != null && pkg != applicationContext.packageName) {
                enforceLimit(pkg)
            }
            scheduleWatchdog()
        }
    }

    private var watchdogArmed = false

    /** Hlídka běží, jen pokud vůbec nějaký limit existuje. */
    private fun scheduleWatchdog() {
        handler.removeCallbacks(limitWatchdog)
        watchdogArmed = false
        if (AppLimits.all(this).isEmpty()) return
        handler.postDelayed(limitWatchdog, LIMIT_CHECK_INTERVAL_MS)
        watchdogArmed = true
    }

    /**
     * Nastartuje hlídku, pokud neběží — třeba proto, že v době spuštění služby
     * ještě žádný limit neexistoval a uživatel si ho přidal až potom.
     * Běžící hlídku nechává být, aby se jí přepínáním oken neodkládal odpočet.
     */
    private fun ensureWatchdog() {
        if (!watchdogArmed) scheduleWatchdog()
    }

    /**
     * Zkontroluje aplikaci, která je v popředí už ve chvíli zapnutí služby.
     *
     * Služba se spouští při zapnutí v nastavení, po restartu telefonu i po
     * aktualizaci aplikace — a v každém z těch okamžiků může být limitovaná
     * aplikace už otevřená. Bez téhle kontroly by se limit vynutil až při
     * příštím přepnutí okna, takže by stačilo aplikaci nepřepínat.
     *
     * Zpoždění je tu proto, že hned po připojení bývá `rootInActiveWindow`
     * ještě prázdné.
     */
    private val initialCheck = Runnable {
        val current = rootInActiveWindow?.packageName?.toString()
        if (current != null && current != applicationContext.packageName) {
            if (!enforceFocusBlock(current)) enforceLimit(current)
        }
        scheduleWatchdog()
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        handler.postDelayed(initialCheck, INITIAL_CHECK_DELAY_MS)
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return

        val packageName = event.packageName?.toString() ?: return

        // Vlastní appku ani systémové UI nikdy neblokujeme — jinak by se
        // uživatel nedostal ani do nastavení, ani do Kotvy samotné.
        if (packageName == applicationContext.packageName) return
        if (packageName == "com.android.systemui") return

        ensureWatchdog()

        // Okamžitá reakce na otevření aplikace; průběžné hlídání pak obstará
        // [limitWatchdog], který běží nezávisle.
        if (enforceFocusBlock(packageName)) return
        enforceLimit(packageName)
    }

    /** Vrací true, pokud byla aplikace zastíněna kvůli běžícímu fokus bloku. */
    private fun enforceFocusBlock(packageName: String): Boolean {
        if (!BlockingState.isActive(this)) {
            lastShielded = null
            return false
        }
        if (packageName !in BlockingState.blockedPackages(this)) return false
        if (isDebouncing(packageName)) return true

        startActivity(
            Intent(this, ShieldActivity::class.java).apply {
                applyOverlayFlags()
                putExtra(ShieldActivity.EXTRA_GOAL, BlockingState.goalText(this@KotvaAccessibilityService))
                putExtra(ShieldActivity.EXTRA_ENDS_AT, BlockingState.endsAt(this@KotvaAccessibilityService))
            },
        )
        return true
    }

    /** Vrací true, pokud byla aplikace zastavena kvůli vyčerpanému limitu. */
    private fun enforceLimit(packageName: String): Boolean {
        val limit = AppLimits.evaluate(this, packageName) ?: return false
        if (isDebouncing(packageName)) return true

        NotificationSuppressor.suppress(this, packageName)

        startActivity(
            Intent(this, LimitReachedActivity::class.java).apply {
                applyOverlayFlags()
                putExtra(LimitReachedActivity.EXTRA_PACKAGE, limit.packageName)
                putExtra(LimitReachedActivity.EXTRA_LABEL, limit.label)
                putExtra(LimitReachedActivity.EXTRA_INTENSITY, limit.intensity.ordinal)
                putExtra(LimitReachedActivity.EXTRA_LIMIT_MINUTES, limit.dailyMinutes)
                putExtra(
                    LimitReachedActivity.EXTRA_USED_MINUTES,
                    AppLimits.usedMinutesToday(this@KotvaAccessibilityService, packageName),
                )
            },
        )
        return true
    }

    /**
     * Aplikace při startu vygeneruje víc událostí za sebou. Bez tlumení by se
     * překryv spustil několikrát a blikal.
     */
    private fun isDebouncing(packageName: String): Boolean {
        val now = System.currentTimeMillis()
        if (packageName == lastShielded && now - lastShieldAt < SHIELD_DEBOUNCE_MS) {
            return true
        }
        lastShielded = packageName
        lastShieldAt = now
        return false
    }

    private fun Intent.applyOverlayFlags() {
        addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TASK or
                Intent.FLAG_ACTIVITY_NO_ANIMATION,
        )
    }

    override fun onInterrupt() = Unit

    override fun onDestroy() {
        handler.removeCallbacks(limitWatchdog)
        handler.removeCallbacks(initialCheck)
        super.onDestroy()
    }

    private companion object {
        const val SHIELD_DEBOUNCE_MS = 1500L

        /**
         * Jak často se za běhu kontroluje vyčerpání limitu. 15 s je kompromis:
         * dost často, aby překročení nebylo znát, a dost zřídka, aby dotaz do
         * `UsageStatsManager` nezatěžoval baterii (docs/spec.md §13).
         */
        const val LIMIT_CHECK_INTERVAL_MS = 15_000L

        /** Odklad první kontroly po připojení služby — viz [initialCheck]. */
        const val INITIAL_CHECK_DELAY_MS = 1_000L
    }
}
