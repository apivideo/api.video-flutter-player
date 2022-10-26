package video.api.flutter.player

import android.content.Context
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.view.TextureRegistry
import video.api.player.models.VideoOptions


class FlutterPlayerController(
    private val textureRegistry: TextureRegistry,
    private val messenger: BinaryMessenger,
    private val applicationContext: Context
) : FlutterPlayerInterface {
    private val players = mutableMapOf<Long, FlutterPlayerView>()

    override fun create(videoOptions: VideoOptions): Long {
        val player = FlutterPlayerView(
            applicationContext,
            messenger,
            textureRegistry,
            videoOptions
        )
        players[player.textureId] = player

        return player.textureId
    }

    override fun dispose(textureId: Long) {
        players[textureId]?.release() ?: Log.e(TAG, "Unknown player $textureId")
        players.remove(textureId)
    }

    override fun disposeAll() {
        players.values.forEach { it.release() }
        players.clear()
    }

    override fun isPlaying(textureId: Long): Boolean {
        return players[textureId]?.isPlaying ?: run {
            Log.e(TAG, "Unknown player $textureId")
            false
        }
    }

    override fun setCurrentTime(textureId: Long, currentTime: Int) {
        players[textureId]?.let { it.currentTime = currentTime.msToFloat() } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getCurrentTime(textureId: Long): Int {
        return players[textureId]?.currentTime?.toMs() ?: run {
            Log.e(TAG, "Unknown player $textureId")
            0
        }
    }

    override fun getDuration(textureId: Long): Int {
        return players[textureId]?.duration?.toMs() ?: run {
            Log.e(TAG, "Unknown player $textureId")
            0
        }
    }

    override fun play(textureId: Long) {
        players[textureId]?.play() ?: Log.e(TAG, "Unknown player $textureId")
    }

    override fun pause(textureId: Long) {
        players[textureId]?.pause() ?: Log.e(TAG, "Unknown player $textureId")
    }

    override fun seek(textureId: Long, offset: Int) {
        players[textureId]?.seek(offset.msToFloat()) ?: Log.e(TAG, "Unknown player $textureId")
    }

    companion object {
        private const val TAG = "ApiVideoPlayerApiController"
    }
}
