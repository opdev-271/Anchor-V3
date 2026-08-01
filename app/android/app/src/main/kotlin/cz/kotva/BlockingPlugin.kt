package cz.kotva

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.os.Process
import android.provider.Settings
import android.text.TextUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Most mezi Flutter částí a nativní blokovací vrstvou (docs/spec.md §5.2).
 *
 * Oprávnění, která tahle vrstva potřebuje, a proč:
 *
 *  - **Přístupnost (AccessibilityService)** — jediný způsob, jak běžná aplikace
 *    zjistí, která aplikace je právě v popředí, a stihne na to zareagovat.
 *    Uděluje se ručně v Nastavení; systém na to nemá runtime dialog, proto
 *    [openAccessibilitySettings] otevírá rovnou tu správnou obrazovku
 *    (požadavek docs/spec.md §8 na čitelný deep link).
 *  - **Přístup k údajům o používání (PACKAGE_USAGE_STATS)** — také se uděluje
 *    ručně v Nastavení, ne dialogem. Slouží k seřazení seznamu aplikací podle
 *    skutečného používání, aby uživatel nemusel hledat mezi stovkami položek.
 *    Blokace na něm **nezávisí** — bez něj se seznam jen seřadí abecedně.
 */
class BlockingPlugin(private val context: Context) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAccessibilityServiceEnabled" ->
                result.success(isAccessibilityServiceEnabled())

            "openAccessibilitySettings" -> {
                openSettings(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                result.success(null)
            }

            "hasUsageAccess" -> result.success(hasUsageAccess())

            "openUsageAccessSettings" -> {
                openSettings(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                result.success(null)
            }

            "getInstalledApps" -> result.success(InstalledApps.list(context))

            "startBlocking" -> {
                val packages = call.argument<List<String>>("packages").orEmpty()
                val goal = call.argument<String>("goalText").orEmpty()
                val endsAt = call.argument<Number>("endsAtMillis")?.toLong() ?: 0L
                BlockingState.start(context, packages.toSet(), goal, endsAt)
                result.success(null)
            }

            "stopBlocking" -> {
                BlockingState.stop(context)
                result.success(null)
            }

            // --- Čas na obrazovce a denní limity ---

            "getTodayUsage" -> result.success(
                UsageTracker.todayByPackage(context).map { (pkg, millis) ->
                    mapOf(
                        "packageName" to pkg,
                        "label" to InstalledApps.labelFor(context, pkg),
                        "minutes" to millis / 60_000,
                    )
                }.sortedByDescending { it["minutes"] as Long },
            )

            "getDailyTotals" -> {
                val days = call.argument<Int>("days") ?: 7
                result.success(
                    UsageTracker.dailyTotals(context, days).map { (dayStart, millis) ->
                        mapOf("dayStart" to dayStart, "minutes" to millis / 60_000)
                    },
                )
            }

            "saveAppLimits" -> {
                val raw = call.argument<List<Map<String, Any>>>("limits").orEmpty()
                AppLimits.save(
                    context,
                    raw.map {
                        AppLimit(
                            packageName = it["packageName"] as String,
                            label = it["label"] as? String ?: "",
                            dailyMinutes = (it["dailyMinutes"] as Number).toInt(),
                            intensity = LimitIntensity.fromIndex(
                                (it["intensity"] as Number).toInt(),
                            ),
                        )
                    },
                )
                result.success(null)
            }

            "isNotificationAccessGranted" ->
                result.success(NotificationSuppressor.isPermissionGranted(context))

            "openNotificationAccessSettings" -> {
                openSettings(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    /**
     * Čte systémový seznam zapnutých služeb přístupnosti a hledá v něm tu naši.
     * Android pro tohle nemá přímé API, string se seznamem je jediná cesta.
     */
    private fun isAccessibilityServiceEnabled(): Boolean {
        val expected = "${context.packageName}/${KotvaAccessibilityService::class.java.name}"
        val enabled = Settings.Secure.getString(
            context.contentResolver,
            Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES,
        ) ?: return false

        val splitter = TextUtils.SimpleStringSplitter(':')
        splitter.setString(enabled)
        while (splitter.hasNext()) {
            if (splitter.next().equals(expected, ignoreCase = true)) return true
        }
        return false
    }

    private fun hasUsageAccess(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.unsafeCheckOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            Process.myUid(),
            context.packageName,
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun openSettings(action: String) {
        context.startActivity(
            Intent(action).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
        )
    }

    companion object {
        const val CHANNEL = "cz.kotva/blocking"
    }
}
