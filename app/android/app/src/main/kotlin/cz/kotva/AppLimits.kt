package cz.kotva

import android.content.Context
import org.json.JSONObject

/**
 * Intenzita vynucení denního limitu.
 *
 * Pořadí odpovídá `LimitIntensity` na Dart straně — indexy se posílají přes
 * MethodChannel, takže se nesmí přeskupovat.
 */
enum class LimitIntensity {
    /** Zeptá se, jestli opravdu prodloužit; povolí 5 minut a zeptá se znovu. */
    ASK,

    /** Prodloužení navíc vyžaduje opsat kód na přeházené klávesnici. */
    CODE,

    /** Bez prodloužení — do konce dne je aplikace zavřená. */
    HARD;

    companion object {
        fun fromIndex(i: Int) = entries.getOrElse(i) { ASK }
    }
}

data class AppLimit(
    val packageName: String,
    val label: String,
    val dailyMinutes: Int,
    val intensity: LimitIntensity,
)

/**
 * Denní limity na aplikace a stav jejich čerpání.
 *
 * Stejně jako [BlockingState] žije v `SharedPreferences`, protože je čte
 * [KotvaAccessibilityService] běžící nezávisle na Flutter enginu.
 */
object AppLimits {
    private const val PREFS = "kotva_limits"
    private const val KEY_LIMITS = "limits_json"
    private const val KEY_EXTENSION_PREFIX = "ext_until_"
    private const val KEY_EXTENSION_COUNT_PREFIX = "ext_count_"

    /** Délka jednoho prodloužení — 5 minut dle zadání. */
    const val EXTENSION_MILLIS = 5 * 60 * 1000L

    private fun prefs(context: Context) =
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    fun save(context: Context, limits: List<AppLimit>) {
        val json = JSONObject()
        for (limit in limits) {
            json.put(
                limit.packageName,
                JSONObject()
                    .put("label", limit.label)
                    .put("minutes", limit.dailyMinutes)
                    .put("intensity", limit.intensity.ordinal),
            )
        }
        prefs(context).edit().putString(KEY_LIMITS, json.toString()).apply()
    }

    fun all(context: Context): List<AppLimit> {
        val raw = prefs(context).getString(KEY_LIMITS, null) ?: return emptyList()
        return try {
            val json = JSONObject(raw)
            json.keys().asSequence().map { pkg ->
                val o = json.getJSONObject(pkg)
                AppLimit(
                    packageName = pkg,
                    label = o.optString("label", pkg),
                    dailyMinutes = o.optInt("minutes", 0),
                    intensity = LimitIntensity.fromIndex(o.optInt("intensity", 0)),
                )
            }.toList()
        } catch (_: Exception) {
            emptyList()
        }
    }

    fun forPackage(context: Context, packageName: String): AppLimit? =
        all(context).firstOrNull { it.packageName == packageName }

    /**
     * Povolí uživateli dalších 5 minut. Počítadlo slouží k tomu, aby šlo
     * uživateli ukázat, po kolikáté už dnes prodlužuje — bez obviňování,
     * jen jako fakt (docs/spec.md §11).
     */
    fun grantExtension(context: Context, packageName: String) {
        val p = prefs(context)
        p.edit()
            .putLong(
                KEY_EXTENSION_PREFIX + packageName,
                System.currentTimeMillis() + EXTENSION_MILLIS,
            )
            .putInt(
                KEY_EXTENSION_COUNT_PREFIX + packageName,
                extensionCountToday(context, packageName) + 1,
            )
            .apply()
    }

    /** True, pokud právě běží povolené prodloužení. */
    fun extensionActive(context: Context, packageName: String): Boolean =
        prefs(context).getLong(KEY_EXTENSION_PREFIX + packageName, 0L) >
            System.currentTimeMillis()

    fun extensionCountToday(context: Context, packageName: String): Int {
        val p = prefs(context)
        // Počítadlo se resetuje s novým dnem — bez toho by po půlnoci
        // navazovalo na včerejšek.
        val storedDay = p.getLong("ext_day_$packageName", 0L)
        val today = UsageTracker.startOfToday()
        if (storedDay != today) {
            p.edit()
                .putLong("ext_day_$packageName", today)
                .putInt(KEY_EXTENSION_COUNT_PREFIX + packageName, 0)
                .apply()
            return 0
        }
        return p.getInt(KEY_EXTENSION_COUNT_PREFIX + packageName, 0)
    }

    /**
     * Rozhodne, jestli má být aplikace právě teď zastavena.
     *
     * Vrací `null`, když se smí používat dál.
     */
    fun evaluate(context: Context, packageName: String): AppLimit? {
        val limit = forPackage(context, packageName) ?: return null
        if (limit.dailyMinutes <= 0) return null
        if (extensionActive(context, packageName)) return null

        val usedMinutes = UsageTracker.todayFor(context, packageName) / 60_000
        return if (usedMinutes >= limit.dailyMinutes) limit else null
    }

    fun usedMinutesToday(context: Context, packageName: String): Int =
        (UsageTracker.todayFor(context, packageName) / 60_000).toInt()

    /**
     * Zahodí limity i stav jejich čerpání — součást smazání všech dat
     * (docs/spec.md §9) a odvolání souhlasu s kategorií `usage_stats`.
     */
    fun clear(context: Context) {
        prefs(context).edit().clear().apply()
    }
}
