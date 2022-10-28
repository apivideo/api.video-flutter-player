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
        methodChannel.setMethodCallHandler(null)
        controller.disposeAll()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            INITIALIZE -> {
                val textureId = try {
                    controller.initialize()
                } catch (e: Exception) {
                    result.error("failed_action", "Failed to initialize a new player", e)
                    return
                }

                val reply: MutableMap<String, Any> = HashMap()
                reply["textureId"] = textureId
                result.success(reply)
            }
            CREATE -> {
                val videoOptions = try {
                    ((call.arguments as Map<*, *>)["videoOptions"] as Map<String, Any>).videoOptions
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid video options", e)
                    return
                }

                ensureTextureId(call, result) {
                    controller.create(it, videoOptions)
                    result.success(null)
                }
            }
            DISPOSE -> {
                ensureTextureId(call, result) {
                    controller.dispose(it)
                    result.success(null)
                }
            }
            IS_PLAYING -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["isPlaying"] = controller.isPlaying(it)
                    result.success(reply)
                }
            }
            GET_CURRENT_TIME -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["currentTime"] = controller.getCurrentTime(it)
                    result.success(reply)
                }
            }
            SET_CURRENT_TIME -> {
                val currentTime = try {
                    ((call.arguments as Map<*, *>)["currentTime"] as Int)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid current time", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setCurrentTime(it, currentTime)
                    result.success(null)
                }
            }
            GET_DURATION -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["duration"] = controller.getDuration(it)
                    result.success(reply)
                }
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
            SEEK -> {
                val offset = try {
                    ((call.arguments as Map<*, *>)["offset"] as Int)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid offset", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.seek(it, offset)
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

        private const val INITIALIZE = "initialize"
        private const val CREATE = "create"
        private const val DISPOSE = "dispose"

        private const val IS_PLAYING = "isPlaying"
        private const val GET_CURRENT_TIME = "getCurrentTime"
        private const val SET_CURRENT_TIME = "setCurrentTime"
        private const val GET_DURATION = "getDuration"

        private const val PLAY = "play"
        private const val PAUSE = "pause"
        private const val SEEK = "seek"
    }
}