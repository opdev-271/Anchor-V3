package cz.kotva

import android.content.ComponentName
import android.content.Context
import android.provider.Settings
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification

/**
 * Potlačuje notifikace z aplikací, jimž došel denní limit.
 *
 * Zadání: „v ten moment z aplikace nebudou chodit ani žádné notifikace."
 *
 * ## Co to umí a co ne
 *
 * Android neumožňuje cizí aplikaci zakázat, aby notifikaci **vytvořila**.
 * Co jde, je odebrat ji hned po zobrazení přes [NotificationListenerService].
 * V praxi to znamená, že notifikace zmizí prakticky okamžitě; může ale krátce
 * probliknout, případně stihnout pípnout. Zvuk potlačit nelze — o přehrání se
 * postará systém dřív, než se o notifikaci vůbec dozvíme.
 *
 * Oprávnění „Přístup k oznámením" uděluje uživatel ručně v Nastavení, stejně
 * jako u služby přístupnosti. Bez něj limity fungují dál, jen notifikace
 * z vyčerpané aplikace chodit budou — proto je celá tahle funkce volitelná
 * a aplikace to říká otevřeně (docs/spec.md §8).
 */
class NotificationSuppressor : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        val pkg = sbn?.packageName ?: return
        if (!isSuppressed(applicationContext, pkg)) return
        // Trvalé notifikace (přehrávač, hovor) neodstraňujeme — nejde
        // o rozptýlení, ale o probíhající činnost, kterou by odebrání rozbilo.
        if (sbn.isOngoing) return
        cancelNotification(sbn.key)
    }

    companion object {
        private const val PREFS = "kotva_notif"
        private const val KEY_PREFIX = "suppress_until_"

        /**
         * Zapne potlačení do konce dne. Konec dne, ne napořád — limit je denní,
         * takže po půlnoci musí notifikace zase chodit.
         */
        fun suppress(context: Context, packageName: String) {
            val endOfDay = UsageTracker.startOfToday() + 24 * 60 * 60 * 1000L
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit()
                .putLong(KEY_PREFIX + packageName, endOfDay)
                .apply()
        }

        /** Zruší potlačení — volá se, když uživatel dostane prodloužení. */
        fun release(context: Context, packageName: String) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit()
                .remove(KEY_PREFIX + packageName)
                .apply()
        }

        /** Zruší potlačení pro všechny aplikace — součást smazání všech dat. */
        fun clear(context: Context) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit()
                .clear()
                .apply()
        }

        fun isSuppressed(context: Context, packageName: String): Boolean =
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .getLong(KEY_PREFIX + packageName, 0L) > System.currentTimeMillis()

        fun isPermissionGranted(context: Context): Boolean {
            val enabled = Settings.Secure.getString(
                context.contentResolver,
                "enabled_notification_listeners",
            ) ?: return false
            val expected = ComponentName(context, NotificationSuppressor::class.java)
            return enabled.split(':').any {
                ComponentName.unflattenFromString(it) == expected
            }
        }
    }
}
