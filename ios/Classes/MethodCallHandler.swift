import ApiVideoPlayer
import Foundation

class MethodCallHandler {
    private let binaryMessenger: FlutterBinaryMessenger
    private let controller: FlutterPlayerController!
    private let methodChannel: FlutterMethodChannel

    init(binaryMessenger: FlutterBinaryMessenger, controller: FlutterPlayerController) {
        self.binaryMessenger = binaryMessenger
        self.controller = controller
        methodChannel = FlutterMethodChannel(name: "video.api.player/controller", binaryMessenger: binaryMessenger)
        methodChannel
            .setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
                switch call.method {
                case Keys.create:
                    guard let args = call.arguments as? [String: Any],
                          let videoOptions = args["videoOptions"] as? [String: Any]
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get arguments for create", details: nil))
                        return
                    }
                    let textureId = self?.controller.create(videoId: videoOptions[Keys.videoId] as! String, videoType: (videoOptions[Keys.videoType] as! String).toVideoType())
                    result([Keys.textureId: textureId])
                case Keys.play:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.play(textureId: Int64(textureId))
                case Keys.pause:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.pause(textureId: Int64(textureId))
                case Keys.dispose:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.dispose(textureId: Int64(textureId))
                default:
                    result(FlutterMethodNotImplemented)
                }
            }
    }

    func dispose() {
        methodChannel.setMethodCallHandler(nil)
        controller.disposeAll()
    }
}

enum Keys {
    static let videoId = "videoId"
    static let videoType = "videoType"
    static let textureId = "textureId"

    static let vod = "vod"
    static let live = "live"

    static let create = "create"
    static let play = "play"
    static let pause = "pause"
    static let dispose = "dispose"
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
