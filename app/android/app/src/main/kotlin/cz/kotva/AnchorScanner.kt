package cz.kotva

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.content.ContextCompat

/**
 * Vyhledávání Bluetooth majáků pro kotevní bod (docs/spec.md §5.3).
 *
 * ## Proč pracovní cyklus a ne souvislé skenování
 *
 * Zadání to vyžaduje výslovně ([§8](../../../../../../../../docs/spec.md)):
 * kotva nesmí citelně brát baterii. Souvislé BLE skenování drží rádio vzhůru
 * a je to jeden z nejdražších způsobů, jak baterii vybít. Proto se skenuje
 * jen v krátkém okně ([SCAN_WINDOW_MS]) a mezi okny se rádio nechá spát
 * ([SCAN_PERIOD_MS]) — zhruba osmiprocentní zátěž místo stoprocentní.
 *
 * Cenou je zpoždění: odchod od stolu se pozná až u některé z dalších kontrol,
 * ne okamžitě. Pro účel aplikace to nevadí — zajímá nás „byl pryč deset minut",
 * ne „vstal na osm vteřin".
 *
 * ## Co tahle cesta neumí
 *
 *  - **Maják musí vysílat.** Fungují iBeacony, Tile a podobné štítky, chytré
 *    hodinky nebo sluchátka v párovacím režimu. Vypnuté zařízení v zásuvce ne.
 *  - **Adresa nemusí být stálá.** Řada zařízení kvůli soukromí mění MAC
 *    adresu v řádu minut; takový maják se po čase tváří jako cizí a kotva
 *    přestane fungovat. Spolehlivé jsou majáky se stálým identifikátorem.
 *    Aplikace to uživateli říká při párování, ne až když to přestane fungovat.
 */
class AnchorScanner(private val context: Context) {

    private val handler = Handler(Looper.getMainLooper())

    private val adapter: BluetoothAdapter?
        get() = (context.getSystemService(Context.BLUETOOTH_SERVICE)
            as? BluetoothManager)?.adapter

    /** Výsledky posledního okna: adresa → síla signálu. */
    private val lastResults = LinkedHashMap<String, ScanResult>()

    private var scanning = false

    fun isSupported(): Boolean = adapter != null

    fun isEnabled(): Boolean = adapter?.isEnabled == true

    /**
     * Od Androidu 12 stačí `BLUETOOTH_SCAN`; starší verze vyžadují polohové
     * oprávnění, protože z okolních majáků šlo polohu odvodit. Kotva polohu
     * neodvozuje a v manifestu to deklaruje (`neverForLocation`).
     */
    fun hasPermission(): Boolean {
        val needed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            Manifest.permission.BLUETOOTH_SCAN
        } else {
            Manifest.permission.ACCESS_FINE_LOCATION
        }
        return ContextCompat.checkSelfPermission(context, needed) ==
            PackageManager.PERMISSION_GRANTED
    }

    /**
     * Spustí jedno skenovací okno a po [SCAN_WINDOW_MS] vrátí nalezená
     * zařízení. Voláním se nic dlouhodobě nerozbíhá — o opakování se stará
     * volající, aby se dal cyklus řídit podle toho, jestli běží fokus blok.
     */
    fun scanOnce(onResult: (List<Map<String, Any>>) -> Unit) {
        if (!hasPermission() || !isEnabled() || scanning) {
            onResult(emptyList())
            return
        }
        val scanner = adapter?.bluetoothLeScanner ?: run {
            onResult(emptyList())
            return
        }

        lastResults.clear()
        scanning = true

        val callback = object : ScanCallback() {
            override fun onScanResult(callbackType: Int, result: ScanResult?) {
                val address = result?.device?.address ?: return
                lastResults[address] = result
            }
        }

        val settings = ScanSettings.Builder()
            // LOW_LATENCY jen po dobu krátkého okna: rychleji najde, co je
            // v dosahu, a tím pádem může být okno kratší. Souvisle by tenhle
            // režim baterii ničil.
            .setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
            .build()

        try {
            scanner.startScan(null, settings, callback)
        } catch (_: SecurityException) {
            scanning = false
            onResult(emptyList())
            return
        }

        handler.postDelayed({
            try {
                scanner.stopScan(callback)
            } catch (_: SecurityException) {
                // Oprávnění mohl uživatel odebrat během okna — nic víc s tím
                // nenaděláme, výsledky prostě nebudou.
            }
            scanning = false
            onResult(lastResults.values.map { it.toMap() })
        }, SCAN_WINDOW_MS)
    }

    private fun ScanResult.toMap(): Map<String, Any> = mapOf(
        "address" to device.address,
        "name" to (deviceNameSafe() ?: ""),
        "rssi" to rssi,
    )

    private fun ScanResult.deviceNameSafe(): String? = try {
        // Vyžaduje BLUETOOTH_CONNECT; bez něj vrátí výjimku a jméno prostě
        // nebude. Kvůli jménu si o další oprávnění neříkáme.
        device.name
    } catch (_: SecurityException) {
        scanRecord?.deviceName
    }

    companion object {
        /** Jak dlouho se v jednom okně poslouchá. */
        const val SCAN_WINDOW_MS = 6_000L

        /**
         * Rozestup mezi okny. Zadání ([§8](../../../../../../../../docs/spec.md))
         * doporučuje 60–90 s; 75 s je střed.
         */
        const val SCAN_PERIOD_MS = 75_000L
    }
}
