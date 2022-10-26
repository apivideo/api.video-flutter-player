package video.api.flutter.player

import video.api.player.models.VideoOptions

interface FlutterPlayerInterface {
    fun create(videoOptions: VideoOptions): Long
    fun dispose(textureId: Long)
    fun disposeAll()

    fun isPlaying(textureId: Long): Boolean
    fun setCurrentTime(textureId: Long, currentTime: Int)
    fun getCurrentTime(textureId: Long): Int
    fun getDuration(textureId: Long): Int

    fun play(textureId: Long)
    fun pause(textureId: Long)
    fun seek(textureId: Long, offset: Int)
}