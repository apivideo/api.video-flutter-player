package video.api.flutter.player

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterApiVideoPlayerViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        return FlutterApiVideoPlayerView(context, messenger, id, args as Map<String, Any>?)
    }
}