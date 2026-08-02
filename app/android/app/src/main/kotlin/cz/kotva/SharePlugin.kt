package cz.kotva

import android.app.Activity
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Předá text systémovému výběru aplikací (docs/spec.md §5.4).
 *
 * Použitý je záměrně `ACTION_SEND`, ne přímé odeslání SMS nebo e-mailu:
 * **zprávu odesílá uživatel, ne aplikace.** Kotva ji jen připraví a nechá ho
 * vybrat, komu a čím ji pošle. Automatické odeslání navenek bez potvrzení by
 * bylo jednání za uživatele — a to si aplikace, která má respektovat jeho
 * autonomii (§11), dovolit nemůže.
 *
 * Vlastní implementace místo balíčku třetí strany: jde o pět řádků nad
 * standardním intentem a nestojí to za další závislost.
 */
class SharePlugin(private val activity: Activity) :
    MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "shareText" -> {
                val text = call.argument<String>("text").orEmpty()
                val title = call.argument<String>("title")
                shareText(text, title)
                result.success(null)
            }

            "shareFile" -> {
                val path = call.argument<String>("path")
                if (path.isNullOrEmpty()) {
                    result.error("no_path", "Chybí cesta k souboru.", null)
                } else {
                    shareFile(path, call.argument<String>("title"))
                    result.success(null)
                }
            }

            else -> result.notImplemented()
        }
    }

    private fun shareText(text: String, title: String?) {
        val send = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
        }
        activity.startActivity(Intent.createChooser(send, title))
    }

    /**
     * Předá soubor s exportem systémovému výběru (docs/spec.md §9, §14).
     *
     * Soubor jde ven jako `content://` URI přes [FileProvider], ne jako `file://`
     * — od Androidu 7 systém sdílení přímé cesty odmítá (`FileUriExposedException`).
     * Cílová aplikace navíc dostane dočasné oprávnění jen k tomuhle jednomu
     * souboru, ne přístup do adresáře Kotvy.
     *
     * Sdílet jako soubor, ne jako text: export může mít stovky kilobajtů
     * a intent s takovým množstvím textu by systém odmítl.
     */
    private fun shareFile(path: String, title: String?) {
        val uri = FileProvider.getUriForFile(
            activity,
            "${activity.packageName}.fileprovider",
            File(path),
        )
        val send = Intent(Intent.ACTION_SEND).apply {
            type = "application/json"
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        activity.startActivity(Intent.createChooser(send, title))
    }

    companion object {
        const val CHANNEL = "cz.kotva/share"
    }
}
