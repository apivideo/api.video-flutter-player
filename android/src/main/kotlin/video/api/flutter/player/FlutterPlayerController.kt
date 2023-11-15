package video.api.flutter.player

import android.content.Context
import android.util.Log
import android.util.Size
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.view.TextureRegistry
import video.api.player.models.VideoOptions


class FlutterPlayerController(
    private val textureRegistry: TextureRegistry,
    private val messenger: BinaryMessenger,
    private val applicationContext: Context
) : FlutterPlayerInterface {
    private val players = mutableMapOf<Long, FlutterPlayerView>()

    override fun isCreated(textureId: Long): Boolean {
        return players.containsKey(textureId)
    }

    override fun initialize(autoplay: Boolean): Long {
        val player = FlutterPlayerView(
            applicationContext,
            messenger,
            textureRegistry,
            null,
            autoplay
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

    override fun isLive(textureId: Long): Boolean {
        return players[textureId]?.isLive ?: run {
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

    override fun getVideoOptions(textureId: Long): VideoOptions? {
        return players[textureId]?.videoOptions ?: run {
            Log.e(TAG, "Unknown player $textureId")
            null
        }
    }

    override fun setVideoOptions(textureId: Long, videoOptions: VideoOptions) {
        players[textureId]?.let { it.videoOptions = videoOptions } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getAutoplay(textureId: Long): Boolean {
        return players[textureId]?.isAutoplay ?: run {
            Log.e(TAG, "Unknown player $textureId")
            false
        }
    }

    override fun setAutoplay(textureId: Long, autoplay: Boolean) {
        players[textureId]?.let { it.isAutoplay = autoplay } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getIsMuted(textureId: Long): Boolean {
        return players[textureId]?.isMuted ?: run {
            Log.e(TAG, "Unknown player $textureId")
            false
        }
    }

    override fun setIsMuted(textureId: Long, isMuted: Boolean) {
        players[textureId]?.let { it.isMuted = isMuted } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getIsLooping(textureId: Long): Boolean {
        return players[textureId]?.isLooping ?: run {
            Log.e(TAG, "Unknown player $textureId")
            false
        }
    }

    override fun setIsLooping(textureId: Long, isLooping: Boolean) {
        players[textureId]?.let { it.isLooping = isLooping } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getVolume(textureId: Long): Float {
        return players[textureId]?.volume ?: run {
            Log.e(TAG, "Unknown player $textureId")
            0.0F
        }
    }

    override fun setVolume(textureId: Long, volume: Float) {
        players[textureId]?.let { it.volume = volume } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
    }

    override fun getVideoSize(textureId: Long): Size? {
        return players[textureId]?.videoSize ?: run {
            Log.e(TAG, "Unknown player $textureId")
            null
        }
    }

    override fun getPlaybackSpeed(textureId: Long): Double {
        return players[textureId]?.playbackSpeed?.toDouble() ?: run {
            Log.e(TAG, "Unknown player $textureId")
            0.0
        }
    }

    override fun setPlaybackSpeed(textureId: Long, playbackSpeed: Double) {
        players[textureId]?.let { it.playbackSpeed = playbackSpeed.toFloat() } ?: Log.e(
            TAG,
            "Unknown player $textureId"
        )
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
        private const val TAG = "FlutterPlayerController"
    }
}
