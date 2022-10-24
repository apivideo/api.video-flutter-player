package video.api.flutter.player

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MethodCallHandler(
    messenger: BinaryMessenger,
    private val controller: FlutterPlayerController
) :
    MethodChannel.MethodCallHandler {
    private val methodChannel = MethodChannel(messenger, "video.api.player/controller")

    init {
        methodChannel.setMethodCallHandler(this)
    }

    fun dispose() {
        controller.disposeAll()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            CREATE -> {
                val videoOptions = try {
                    ((call.arguments as Map<String, Any>)["videoOptions"] as Map<String, Any>).videoOptions
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid video options", e)
                    return
                }
                val textureId = try {
                    controller.create(videoOptions)
                } catch (e: Exception) {
                    result.error("failed_action", "Failed to create a new player", e)
                    return
                }

                val reply: MutableMap<String, Any> = HashMap()
                reply["textureId"] = textureId
                result.success(reply)
            }
            PLAY -> {
                ensureTextureId(call, result) {
                    controller.play(it)
                    result.success(null)
                }
            }
            PAUSE -> {
                ensureTextureId(call, result) {
                    controller.pause(it)
                    result.success(null)
                }
            }
            DISPOSE -> {
                ensureTextureId(call, result) {
                    controller.dispose(it)
                    result.success(null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun ensureTextureId(
        call: MethodCall,
        result: MethodChannel.Result,
        action: (Long) -> Unit
    ) {
        call.argument<Int>(TEXTURE_ID)?.let {
            action(it.toLong())
        } ?: result.error("missing_parameter", "Missing texture Id", null)
    }

    companion object {
        private const val TAG = "ApiVideoPlayerApi"

        private const val TEXTURE_ID = "textureId"

        private const val CREATE = "create"
        private const val PLAY = "play"
        private const val PAUSE = "pause"
        private const val DISPOSE = "dispose"
    }
}