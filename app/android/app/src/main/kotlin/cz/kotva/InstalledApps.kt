package cz.kotva

import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import java.util.concurrent.TimeUnit

/**
 * Seznam spustitelných aplikací pro výběr do blokovacího seznamu.
 *
 * Vrací jen aplikace, které mají launcher ikonu — systémové balíčky bez UI by
 * uživateli v seznamu k ničemu nebyly. Vlastní aplikaci ze seznamu vynechává:
 * zablokovat Kotvu Kotvou nedává smysl a uživatel by se nedostal k ukončení
 * bloku.
 */
object InstalledApps {

    fun list(context: Context): List<Map<String, Any>> {
        val pm = context.packageManager
        val launcherIntent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)

        @Suppress("DEPRECATION")
        val resolved = pm.queryIntentActivities(launcherIntent, 0)

        val usage = usageMinutesByPackage(context)

        return resolved
            .asSequence()
            .map { it.activityInfo.packageName }
            .filter { it != context.packageName }
            .distinct()
            .map { packageName ->
                mapOf<String, Any>(
                    "packageName" to packageName,
                    "label" to loadLabel(pm, packageName),
                    "usageMinutes" to (usage[packageName] ?: 0L),
                )
            }
            .sortedWith(
                // Nejpoužívanější nahoru — uživatel typicky blokuje právě ty.
                // Bez oprávnění k údajům o používání je mapa prázdná a řazení
                // spadne na abecedu, což je pořád použitelné.
                compareByDescending<Map<String, Any>> { it["usageMinutes"] as Long }
                    .thenBy { (it["label"] as String).lowercase() },
            )
            .toList()
    }

    private fun loadLabel(pm: PackageManager, packageName: String): String = try {
        @Suppress("DEPRECATION")
        pm.getApplicationLabel(pm.getApplicationInfo(packageName, 0)).toString()
    } catch (_: PackageManager.NameNotFoundException) {
        packageName
    }

    /**
     * Čas v popředí za posledních 7 dní podle [UsageStatsManager].
     *
     * Bez uděleného oprávnění vrací systém prázdný seznam — nevyhazuje chybu.
     * Proto tu není žádná kontrola oprávnění: prázdná mapa je legitimní stav.
     */
    private fun usageMinutesByPackage(context: Context): Map<String, Long> {
        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return emptyMap()

        val end = System.currentTimeMillis()
        val start = end - TimeUnit.DAYS.toMillis(7)

        return try {
            usm.queryUsageStats(UsageStatsManager.INTERVAL_BEST, start, end)
                .orEmpty()
                .groupBy { it.packageName }
                .mapValues { (_, stats) ->
                    TimeUnit.MILLISECONDS.toMinutes(stats.sumOf { it.totalTimeInForeground })
                }
        } catch (_: Exception) {
            emptyMap()
        }
    }
}
