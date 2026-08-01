package cz.kotva

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import java.util.Calendar

/**
 * Měření času stráveného v jednotlivých aplikacích.
 *
 * Staví na [UsageStatsManager.queryEvents], ne na `queryUsageStats`. Důvod:
 * `queryUsageStats` vrací předpočítané intervaly, které mohou přesahovat
 * zadané období, takže „kolik jsem dnes strávil v Chrome" z nich vyjde nepřesně.
 * Z jednotlivých událostí popředí a pozadí se dá čas složit přesně, což je pro
 * denní limity ([AppLimits]) nutnost — jinak by se limit spouštěl dřív nebo
 * později, než uživatel čeká.
 *
 * Vyžaduje oprávnění „Přístup k údajům o používání". Bez něj systém vrátí
 * prázdný proud událostí; funkce pak hlásí nulu místo pádu.
 */
object UsageTracker {

    /** Čas v popředí za dnešek, po balíčcích, v milisekundách. */
    fun todayByPackage(context: Context): Map<String, Long> =
        rangeByPackage(context, startOfToday(), System.currentTimeMillis())

    /** Čas v popředí konkrétní aplikace za dnešek, v milisekundách. */
    fun todayFor(context: Context, packageName: String): Long =
        todayByPackage(context)[packageName] ?: 0L

    /** Součet času ve všech aplikacích za dnešek, v milisekundách. */
    fun todayTotal(context: Context): Long =
        todayByPackage(context).values.sum()

    /**
     * Čas v popředí po dnech za posledních [days] dní (dnešek včetně).
     * Klíč je půlnoc daného dne v milisekundách.
     */
    fun dailyTotals(context: Context, days: Int): Map<Long, Long> {
        val result = LinkedHashMap<Long, Long>()
        val dayMillis = 24 * 60 * 60 * 1000L
        val todayStart = startOfToday()
        for (i in (days - 1) downTo 0) {
            val from = todayStart - i * dayMillis
            val to = minOf(from + dayMillis, System.currentTimeMillis())
            result[from] = rangeByPackage(context, from, to).values.sum()
        }
        return result
    }

    /**
     * Balíček, který je právě v popředí — poslední `ACTIVITY_RESUMED`, ke
     * kterému ještě nepřišlo odpovídající `ACTIVITY_PAUSED`.
     *
     * Hlídka limitů se na tohle ptá sama místo toho, aby si popředí pamatovala
     * z událostí přístupnosti. Ta cesta se ukázala jako křehká: stačila
     * jediná událost z jiného balíčku a hlídka se odmlčela, takže limit šlo
     * obejít prostým nepřepínáním aplikace.
     */
    fun currentForegroundPackage(context: Context): String? {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return null

        val now = System.currentTimeMillis()
        // Hodina zpět bohatě stačí a drží dotaz malý.
        val from = now - 60 * 60 * 1000L

        var current: String? = null
        try {
            val events = usm.queryEvents(from, now)
            val event = UsageEvents.Event()
            while (events.hasNextEvent()) {
                events.getNextEvent(event)
                when (event.eventType) {
                    UsageEvents.Event.ACTIVITY_RESUMED -> current = event.packageName
                    UsageEvents.Event.ACTIVITY_PAUSED,
                    UsageEvents.Event.ACTIVITY_STOPPED ->
                        if (event.packageName == current) current = null
                }
            }
        } catch (_: Exception) {
            return null
        }
        return current
    }

    private fun rangeByPackage(context: Context, from: Long, to: Long): Map<String, Long> {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return emptyMap()

        val totals = HashMap<String, Long>()
        // Kdy naposledy přešel který balíček do popředí a ještě se nevrátil.
        val openedAt = HashMap<String, Long>()

        try {
            val events = usm.queryEvents(from, to)
            val event = UsageEvents.Event()
            while (events.hasNextEvent()) {
                events.getNextEvent(event)
                when (event.eventType) {
                    UsageEvents.Event.ACTIVITY_RESUMED ->
                        openedAt[event.packageName] = event.timeStamp

                    UsageEvents.Event.ACTIVITY_PAUSED,
                    UsageEvents.Event.ACTIVITY_STOPPED -> {
                        val start = openedAt.remove(event.packageName) ?: continue
                        val delta = event.timeStamp - start
                        if (delta > 0) {
                            totals[event.packageName] =
                                (totals[event.packageName] ?: 0L) + delta
                        }
                    }
                }
            }

            // Aplikace, která je v popředí právě teď, ještě událost o odchodu
            // nevygenerovala — bez tohohle by se běžící relace nezapočítala
            // a limit by se nikdy nespustil.
            for ((pkg, start) in openedAt) {
                val delta = to - start
                if (delta > 0) {
                    totals[pkg] = (totals[pkg] ?: 0L) + delta
                }
            }
        } catch (_: Exception) {
            return emptyMap()
        }

        return totals
    }

    fun startOfToday(): Long = Calendar.getInstance().apply {
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
    }.timeInMillis
}
