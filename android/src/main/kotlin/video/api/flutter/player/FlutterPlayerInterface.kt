package video.api.flutter.player

import video.api.player.models.VideoOptions

interface FlutterPlayerInterface {
    fun create(videoOptions: VideoOptions): Long

    fun play(textureId: Long)
    fun pause(textureId: Long)

    fun dispose(textureId: Long)
    fun disposeAll()
}