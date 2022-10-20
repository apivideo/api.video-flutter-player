import Foundation
import ApiVideoPlayer

class FlutterApiVideoPlayerView: NSObject, FlutterPlatformView {
    let playerView: ApiVideoPlayerView
    let methodChannel: FlutterMethodChannel
    
    init(frame: CGRect,
         binaryMessenger: FlutterBinaryMessenger,
         id: Int64,
         creationParams: [String: Any]? = nil
    ) {
        methodChannel = FlutterMethodChannel(name: "plugins.video.api/apivideo_player_\(id)", binaryMessenger: binaryMessenger)
        playerView = ApiVideoPlayerView(frame: frame, videoId: creationParams![Keys.videoId] as! String, videoType: (creationParams![Keys.videoType] as! String).toVideoType())
        super.init()
        self.methodChannel
            .setMethodCallHandler({ [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case Keys.play:
                self?.playerView.play()
            case Keys.pause:
                self?.playerView.pause()
            default:
                result(FlutterMethodNotImplemented)
            }
        })
    }
    
    func view() -> UIView {
        return playerView
    }
}

enum ApiVideoPlayerError: Error {
    case invalidParameter(String)
}

extension String {
    func toVideoType() -> VideoType {
        switch self {
        case Keys.vod:
            return VideoType.vod
        case Keys.live:
            return VideoType.live
        default:
            return VideoType.vod
        }
    }
}

struct Keys {
    static let videoId = "videoId"
    static let videoType = "videoType"
    
    static let vod = "vod"
    static let live = "live"
    
    static let play = "play"
    static let pause = "pause"
}

