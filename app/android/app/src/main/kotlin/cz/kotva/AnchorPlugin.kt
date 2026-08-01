package cz.kotva

import android.Manifest
import android.app.Activity
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.os.Build
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Most do nativní vrstvy kotevních bodů (docs/spec.md §5.3).
 *
 * Na rozdíl od [BlockingPlugin] potřebuje Activity: NFC čtečku i žádost
 * o oprávnění umí spustit jen popředí aplikace.
 *
 * ## NFC má jiné možnosti než Bluetooth
 *
 * Android neumožňuje číst NFC štítky na pozadí — tag se přečte jedině tehdy,
 * když je aplikace v popředí a uživatel k němu telefon přiloží. NFC kotva tedy
 * **nemůže hlídat, jestli uživatel od stolu odešel**; funguje jako rituál
 * („přilož a začni"). Průběžnou přítomnost umí jen Bluetooth maják.
 * Aplikace to říká uživateli při volbě typu kotvy, ne až když to nefunguje.
 */
class AnchorPlugin(
    private val activity: Activity,
    private val channel: MethodChannel,
) : MethodChannel.MethodCallHandler {

    private val scanner = AnchorScanner(activity)
    private var nfcAdapter: NfcAdapter? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "bleStatus" -> result.success(
                mapOf(
                    "supported" to scanner.isSupported(),
                    "enabled" to scanner.isEnabled(),
                    "permitted" to scanner.hasPermission(),
                ),
            )

            "requestBlePermission" -> {
                requestBlePermission()
                result.success(null)
            }

            "scanOnce" -> scanner.scanOnce { devices -> result.success(devices) }

            "nfcAvailable" -> result.success(
                NfcAdapter.getDefaultAdapter(activity)?.isEnabled == true,
            )

            "startNfcReader" -> {
                startNfcReader()
                result.success(null)
            }

            "stopNfcReader" -> {
                stopNfcReader()
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    private fun requestBlePermission() {
        val permissions = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            arrayOf(Manifest.permission.BLUETOOTH_SCAN)
        } else {
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION)
        }
        ActivityCompat.requestPermissions(activity, permissions, REQUEST_CODE)
    }

    private fun startNfcReader() {
        val adapter = NfcAdapter.getDefaultAdapter(activity) ?: return
        nfcAdapter = adapter
        adapter.enableReaderMode(
            activity,
            { tag: Tag -> onTagDiscovered(tag) },
            NfcAdapter.FLAG_READER_NFC_A or
                NfcAdapter.FLAG_READER_NFC_B or
                NfcAdapter.FLAG_READER_NFC_F or
                NfcAdapter.FLAG_READER_NFC_V or
                // Bez zvuku systému: přiložení štítku uprostřed fokus bloku
                // nemá vydávat zvuk (§5.3 — kotva nemá rušit).
                NfcAdapter.FLAG_READER_NO_PLATFORM_SOUNDS,
            null,
        )
    }

    private fun stopNfcReader() {
        nfcAdapter?.disableReaderMode(activity)
        nfcAdapter = null
    }

    private fun onTagDiscovered(tag: Tag) {
        val id = tag.id.joinToString("") { "%02X".format(it) }
        // Callback přichází z vlákna NFC; MethodChannel se smí volat jen
        // z hlavního vlákna.
        activity.runOnUiThread {
            channel.invokeMethod("onNfcTag", mapOf("id" to id))
        }
    }

    companion object {
        const val CHANNEL = "cz.kotva/anchor"
        private const val REQUEST_CODE = 4711
    }
}
