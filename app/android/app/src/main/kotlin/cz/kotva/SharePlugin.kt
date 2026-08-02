package cz.kotva

import android.app.Activity
import android.content.Intent
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

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

    companion object {
        const val CHANNEL = "cz.kotva/share"
    }
}
