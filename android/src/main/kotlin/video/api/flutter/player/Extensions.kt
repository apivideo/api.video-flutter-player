package video.api.flutter.player

import video.api.player.models.VideoOptions
import video.api.player.models.VideoType
import java.security.InvalidParameterException

val Map<String, Any>.videoOptions: VideoOptions
    get() = VideoOptions(
        this["videoId"] as String,
        (this["videoType"] as String).toVideoType(),
        this["privateToken"] as String?
    )

fun String.toVideoType(): VideoType {
    return if (this == "vod") {
        VideoType.VOD
    } else if (this == "live") {
        VideoType.LIVE
    } else {
        throw InvalidParameterException("$this is an unknown video type")
    }
}

fun Int.msToFloat(): Float {
    return this.toFloat() / 1000
}

fun Float.toMs(): Int {
    return (this * 1000).toInt()
}