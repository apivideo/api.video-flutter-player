package video.api.flutter.player

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** ApiVideoPlayerPlugin */
class ApiVideoPlayerPlugin : FlutterPlugin {

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "plugins.video.api/flutter_player_view",
            ApiVideoPlayerViewFactory(flutterPluginBinding.binaryMessenger)
        )
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        // TODO
    }
}
