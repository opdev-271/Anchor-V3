package cz.kotva

import android.content.Context

/**
 * Sdílený stav blokování mezi Flutter částí a [KotvaAccessibilityService].
 *
 * Proč SharedPreferences a ne MethodChannel: AccessibilityService běží ve
 * vlastním procesním kontextu nezávisle na Flutter enginu. Když uživatel appku
 * odsune z popředí, Flutter engine může být uspaný nebo zabitý — služba ale musí
 * dál vědět, co blokovat. Prefs jsou jediný stav, který obojí spolehlivě sdílí.
 */
object BlockingState {
    private const val PREFS = "kotva_blocking"
    private const val KEY_ACTIVE = "active"
    private const val KEY_PACKAGES = "packages"
    private const val KEY_GOAL = "goal"
    private const val KEY_ENDS_AT = "ends_at"

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun start(
        context: Context,
        packages: Set<String>,
        goalText: String,
        endsAtMillis: Long,
    ) {
        prefs(context).edit()
            .putBoolean(KEY_ACTIVE, true)
            .putStringSet(KEY_PACKAGES, packages)
            .putString(KEY_GOAL, goalText)
            .putLong(KEY_ENDS_AT, endsAtMillis)
            .apply()
    }

    fun stop(context: Context) {
        prefs(context).edit().putBoolean(KEY_ACTIVE, false).apply()
    }

    /**
     * True, pokud blok běží a ještě neuplynul jeho čas.
     *
     * Kontrola času je tu záměrně i na nativní straně: kdyby Flutter část
     * nestihla blokování vypnout (zabitý proces, restart telefonu), nesmí
     * uživateli zůstat blokované aplikace navždy.
     */
    fun isActive(context: Context): Boolean {
        val p = prefs(context)
        if (!p.getBoolean(KEY_ACTIVE, false)) return false
        if (System.currentTimeMillis() >= p.getLong(KEY_ENDS_AT, 0L)) {
            stop(context)
            return false
        }
        return true
    }

    fun blockedPackages(context: Context): Set<String> =
        prefs(context).getStringSet(KEY_PACKAGES, emptySet()) ?: emptySet()

    fun goalText(context: Context): String =
        prefs(context).getString(KEY_GOAL, "") ?: ""

    fun endsAt(context: Context): Long = prefs(context).getLong(KEY_ENDS_AT, 0L)

    /**
     * Zahodí celý stav blokování — součást smazání všech dat (docs/spec.md §9).
     *
     * Maže se všechno, ne jen příznak `active`: v prefs zůstávají i názvy
     * blokovaných balíčků a text cíle, což jsou data o uživateli.
     */
    fun clear(context: Context) {
        prefs(context).edit().clear().apply()
    }
}
