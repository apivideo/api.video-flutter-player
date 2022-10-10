package video.api.flutter.player

import android.content.Context
import android.util.Log
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.platform.PlatformView
import video.api.player.ApiVideoExoPlayerView
import video.api.player.ApiVideoPlayerController

class FlutterApiVideoPlayerView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    creationsParams: Map<String, Any>? = null
) :
    PlatformView, MethodCallHandler {
    private val playerView = ApiVideoExoPlayerView(context)
    private val listener = object : ApiVideoPlayerController.Listener {
        override fun onError(error: Exception) {
            Log.e(TAG, "An error occured: ${error.message}", error)
        }
    }

    private val playerController = creationsParams?.let {
        ApiVideoPlayerController(context, it.videoOptions, listener, playerView = playerView)
    } ?: ApiVideoPlayerController(context, null, listener, playerView = playerView)
    private val methodChannel =
        MethodChannel(messenger, "plugins.video.api/apivideo_player_$id")

    init {
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View {
        return playerView
    }

    override fun dispose() {
        playerController.release()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            PLAY -> try {
                playerController.play()
                result.success(null)
            } catch (e: Exception) {
                result.error(e.message!!, e.message!!, null) // TODO
            }
            PAUSE -> try {
                playerController.pause()
                result.success(null)
            } catch (e: Exception) {
                result.error(e.message!!, e.message!!, null)// TODO
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        private const val TAG = "FlutterPlayerView"

        private const val PLAY = "play"
        private const val PAUSE = "pause"
    }
}