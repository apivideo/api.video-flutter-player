package video.api.flutter.player

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.view.TextureRegistry

/** ApiVideoPlayerPlugin */
class ApiVideoPlayerPlugin : FlutterPlugin {
    private lateinit var textureRegistry: TextureRegistry
    private lateinit var messenger: BinaryMessenger
    private lateinit var applicationContext: Context
    private lateinit var api: MethodCallHandler

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        textureRegistry = flutterPluginBinding.textureRegistry
        messenger = flutterPluginBinding.binaryMessenger
        applicationContext = flutterPluginBinding.applicationContext
        api = MethodCallHandler(
            messenger,
            FlutterPlayerController(textureRegistry, messenger, applicationContext)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        api.dispose()
    }
}