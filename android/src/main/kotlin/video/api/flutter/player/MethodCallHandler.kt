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
            IS_CREATED -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["isCreated"] = controller.isCreated(it)
                    result.success(reply)
                }
            }
            INITIALIZE -> {
                val autoplay = try {
                    ((call.arguments as Map<*, *>)["autoplay"] as Boolean)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid autoplay", e)
                    return
                }
                val textureId = try {
                    controller.initialize(autoplay)
                } catch (e: Exception) {
                    result.error("failed_action", "Failed to initialize a new player", e)
                    return
                }

                val reply: MutableMap<String, Any> = HashMap()
                reply["textureId"] = textureId
                result.success(reply)
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
            IS_LIVE -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["isLive"] = controller.isLive(it)
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
            GET_VIDEO_OPTIONS -> {
                ensureTextureId(call, result) {
                    val videoOptions =
                        controller.getVideoOptions(it)!! // As it is mandatory to set a video option. This should never be null.
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["videoId"] = videoOptions.mediaId
                    reply["type"] = videoOptions.videoType.toFlutterString()
                    result.success(reply)
                }
            }
            SET_VIDEO_OPTIONS -> {
                val videoOptions = try {
                    @Suppress("UNCHECKED_CAST")
                    ((call.arguments as Map<*, *>)["videoOptions"] as Map<String, Any>).videoOptions
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid video options", e)
                    return
                }

                ensureTextureId(call, result) {
                    controller.setVideoOptions(it, videoOptions)
                    result.success(null)
                }
            }
            GET_AUTOPLAY -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["autoplay"] = controller.getAutoplay(it)
                    result.success(reply)
                }
            }
            SET_AUTOPLAY -> {
                val autoplay = try {
                    ((call.arguments as Map<*, *>)["autoplay"] as Boolean)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid autoplay", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setAutoplay(it, autoplay)
                    result.success(null)
                }
            }
            GET_IS_MUTED -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["isMuted"] = controller.getIsMuted(it)
                    result.success(reply)
                }
            }
            SET_IS_MUTED -> {
                val isMuted = try {
                    ((call.arguments as Map<*, *>)["isMuted"] as Boolean)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid isMuted", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setIsMuted(it, isMuted)
                    result.success(null)
                }
            }
            GET_IS_LOOPING -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["isLooping"] = controller.getIsLooping(it)
                    result.success(reply)
                }
            }
            SET_IS_LOOPING -> {
                val isLooping = try {
                    ((call.arguments as Map<*, *>)["isLooping"] as Boolean)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid isLooping", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setIsLooping(it, isLooping)
                    result.success(null)
                }
            }
            GET_VOLUME -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["volume"] = controller.getVolume(it).toDouble()
                    result.success(reply)
                }
            }
            SET_VOLUME -> {
                val volume = try {
                    ((call.arguments as Map<*, *>)["volume"] as Double).toFloat()
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid volume", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setVolume(it, volume)
                    result.success(null)
                }
            }
            GET_VIDEO_SIZE -> {
                ensureTextureId(call, result) {
                    val videoSize = controller.getVideoSize(it)
                    val reply: MutableMap<String, Any> = HashMap()
                    videoSize?.let { size ->
                        reply["width"] = size.width.toDouble()
                        reply["height"] = size.height.toDouble()
                    }
                    result.success(reply)
                }
            }

            SET_PLAYBACK_SPEED -> {
                val speed = try {
                    ((call.arguments as Map<*, *>)["speedRate"] as Double)
                } catch (e: Exception) {
                    result.error("invalid_parameter", "Invalid speed", e)
                    return
                }
                ensureTextureId(call, result) {
                    controller.setPlaybackSpeed(it, speed)
                    result.success(null)
                }
            }

            GET_PLAYBACK_SPEED -> {
                ensureTextureId(call, result) {
                    val reply: MutableMap<String, Any> = HashMap()
                    reply["speedRate"] = controller.getPlaybackSpeed(it).toDouble()
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

        private const val IS_CREATED = "isCreated"
        private const val INITIALIZE = "initialize"
        private const val DISPOSE = "dispose"

        private const val IS_PLAYING = "isPlaying"
        private const val IS_LIVE = "isLive"
        private const val GET_CURRENT_TIME = "getCurrentTime"
        private const val SET_CURRENT_TIME = "setCurrentTime"
        private const val GET_DURATION = "getDuration"
        private const val GET_VIDEO_OPTIONS = "getVideoOptions"
        private const val SET_VIDEO_OPTIONS = "setVideoOptions"
        private const val GET_AUTOPLAY = "getAutoplay"
        private const val SET_AUTOPLAY = "setAutoplay"
        private const val GET_IS_LOOPING = "getIsLooping"
        private const val SET_IS_LOOPING = "setIsLooping"
        private const val GET_IS_MUTED = "getIsMuted"
        private const val SET_IS_MUTED = "setIsMuted"
        private const val GET_VOLUME = "getVolume"
        private const val SET_VOLUME = "setVolume"
        private const val GET_VIDEO_SIZE = "getVideoSize"
        private const val GET_PLAYBACK_SPEED = "getPlaybackSpeed"
        private const val SET_PLAYBACK_SPEED = "setPlaybackSpeed"

        private const val PLAY = "play"
        private const val PAUSE = "pause"
        private const val SEEK = "seek"
    }
}