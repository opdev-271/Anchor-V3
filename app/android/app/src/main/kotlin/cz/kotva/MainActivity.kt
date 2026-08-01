package cz.kotva

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, BlockingPlugin.CHANNEL)
            .setMethodCallHandler(BlockingPlugin(applicationContext))

        // Kotvy potřebují Activity — NFC čtečka i žádost o oprávnění jdou
        // spustit jen z popředí aplikace.
        val anchorChannel = MethodChannel(messenger, AnchorPlugin.CHANNEL)
        anchorChannel.setMethodCallHandler(AnchorPlugin(this, anchorChannel))
    }
}
