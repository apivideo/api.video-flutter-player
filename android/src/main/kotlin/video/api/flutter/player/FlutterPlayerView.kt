package video.api.flutter.player

import android.content.Context
import android.util.Log
import android.view.Surface
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.view.TextureRegistry
import video.api.player.ApiVideoPlayerController
import video.api.player.models.VideoOptions

class FlutterPlayerView(
    context: Context,
    messenger: BinaryMessenger,
    textureRegistry: TextureRegistry,
    videoOptions: VideoOptions? = null
) {
    private val surfaceTextureEntry = textureRegistry.createSurfaceTexture()
    val textureId = surfaceTextureEntry.id()
    private val surface = Surface(surfaceTextureEntry.surfaceTexture())
    private val listener = object : ApiVideoPlayerController.Listener {
        override fun onError(error: Exception) {
            Log.e(TAG, "An error occurred: ${error.message}", error)
        }
    }

    private val playerController = videoOptions?.let {
        ApiVideoPlayerController(context, it, listener, surface = surface)
    } ?: ApiVideoPlayerController(context, null, listener, surface = surface)

    fun play() = playerController.play()
    fun pause() = playerController.pause()

    fun release() {
        playerController.stop()
        surfaceTextureEntry.release()
        surface.release()
        playerController.release()
    }

    companion object {
        private const val TAG = "FlutterPlayerView"
    }
}