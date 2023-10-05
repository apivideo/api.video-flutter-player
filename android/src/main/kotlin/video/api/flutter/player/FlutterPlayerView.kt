package video.api.flutter.player

import android.content.Context
import android.util.Log
import android.util.Size
import android.view.Surface
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.view.TextureRegistry
import video.api.player.ApiVideoPlayerController
import video.api.player.models.VideoOptions
import video.api.player.models.VideoType

class FlutterPlayerView(
    context: Context,
    messenger: BinaryMessenger,
    textureRegistry: TextureRegistry,
    initialVideoOptions: VideoOptions? = null,
    autoplay: Boolean = false
) {
    private val surfaceTextureEntry = textureRegistry.createSurfaceTexture()
    val textureId = surfaceTextureEntry.id()
    private val surface = Surface(surfaceTextureEntry.surfaceTexture())
    private val listener = object : ApiVideoPlayerController.Listener {
        override fun onReady() {
            val event = mutableMapOf<String, Any>()
            event["type"] = "ready"
            eventSink?.success(event)
        }

        override fun onPlay() {
            val event = mutableMapOf<String, Any>()
            event["type"] = "played"
            eventSink?.success(event)
        }

        override fun onPause() {
            val event = mutableMapOf<String, Any>()
            event["type"] = "paused"
            eventSink?.success(event)
        }

        override fun onEnd() {
            val event = mutableMapOf<String, Any>()
            event["type"] = "ended"
            eventSink?.success(event)
        }

        override fun onSeek() {
            val event = mutableMapOf<String, Any>()
            event["type"] = "seek"
            eventSink?.success(event)
        }

        override fun onError(error: Exception) {
            Log.e(TAG, "An error occurred: ${error.message}", error)
            eventSink?.error(error::class.java.name, error.message, error)
        }
    }

    private val playerController = initialVideoOptions?.let {
        ApiVideoPlayerController(
            context,
            it,
            listener = listener,
            surface = surface,
            initialAutoplay = autoplay
        )
    } ?: ApiVideoPlayerController(
        context,
        null,
        listener = listener,
        surface = surface,
        initialAutoplay = autoplay
    )
    private var eventSink: EventSink? = null
    private val eventChannel = EventChannel(messenger, "video.api.player/events$textureId")

    init {
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink?.endOfStream()
                eventSink = null
            }
        })
    }

    var videoOptions: VideoOptions?
        get() = playerController.videoOptions
        set(value) {
            playerController.videoOptions = value
        }

    var isAutoplay: Boolean
        get() = playerController.autoplay
        set(value) {
            playerController.autoplay = value
        }

    var isMuted: Boolean
        get() = playerController.isMuted
        set(value) {
            playerController.isMuted = value
        }

    var isLooping: Boolean
        get() = playerController.isLooping
        set(value) {
            playerController.isLooping = value
        }

    var volume: Float
        get() = playerController.volume
        set(value) {
            playerController.volume = value
        }

    val isPlaying: Boolean
        get() = playerController.isPlaying

    val isLive: Boolean
        get() = playerController.isLive

    var currentTime: Float
        get() = playerController.currentTime
        set(value) {
            eventSink?.success(mapOf("type" to "seekStarted"))
            playerController.currentTime = value
        }

    val duration: Float
        get() = playerController.duration

    val videoSize: Size?
        get() = playerController.videoSize

    var playbackSpeed: Float
        get() = playerController.playbackSpeed
        set(value) {
            playerController.playbackSpeed = value
        }

    fun play() = playerController.play()
    fun pause() = playerController.pause()

    fun seek(offset: Float) {
        eventSink?.success(mapOf("type" to "seekStarted"))
        playerController.seek(offset)
    }

    fun release() {
        eventChannel.setStreamHandler(null)
        playerController.stop()
        surfaceTextureEntry.release()
        surface.release()
        playerController.release()
    }

    companion object {
        private const val TAG = "FlutterPlayerView"
    }
}