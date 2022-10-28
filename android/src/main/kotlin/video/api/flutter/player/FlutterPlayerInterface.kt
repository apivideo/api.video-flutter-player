package video.api.flutter.player

import video.api.player.models.VideoOptions

interface FlutterPlayerInterface {
    fun initialize(): Long
    fun dispose(textureId: Long)
    fun disposeAll()

    fun isPlaying(textureId: Long): Boolean
    fun getCurrentTime(textureId: Long): Int
    fun setCurrentTime(textureId: Long, currentTime: Int)
    fun getDuration(textureId: Long): Int
    fun getVideoOptions(textureId: Long): VideoOptions?
    fun setVideoOptions(textureId: Long, videoOptions: VideoOptions)
    fun getAutoplay(textureId: Long): Boolean
    fun setAutoplay(textureId: Long, autoplay: Boolean)
    fun getIsMuted(textureId: Long): Boolean
    fun setIsMuted(textureId: Long, isMuted: Boolean)
    fun getIsLooping(textureId: Long): Boolean
    fun setIsLooping(textureId: Long, isLooping: Boolean)
    fun getVolume(textureId: Long): Float
    fun setVolume(textureId: Long, volume: Float)

    fun play(textureId: Long)
    fun pause(textureId: Long)
    fun seek(textureId: Long, offset: Int)
}