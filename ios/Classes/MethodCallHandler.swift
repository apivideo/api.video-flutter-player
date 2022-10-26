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
                case Keys.dispose:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.dispose(textureId: Int64(textureId))
                case Keys.isPlaying:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isPlaying": self?.controller.isPlaying(textureId: Int64(textureId))])
                case Keys.getCurrentTime:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["currentTime": self?.controller.getCurrentTime(textureId: Int64(textureId))])
                case Keys.setCurrentTime:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let currentTime = args["currentTime"] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or current time", details: nil))
                        return
                    }
                    self?.controller.setCurrentTime(textureId: Int64(textureId), currentTime: currentTime)
                case Keys.getDuration:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["duration": self?.controller.getDuration(textureId: Int64(textureId))])
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
                case Keys.seek:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let offset = args["offset"] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or offset", details: nil))
                        return
                    }
                    self?.controller.seek(textureId: Int64(textureId), offset: offset)
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
    static let dispose = "dispose"

    static let isPlaying = "isPlaying"
    static let getCurrentTime = "getCurrentTime"
    static let setCurrentTime = "setCurrentTime"
    static let getDuration = "getDuration"

    static let play = "play"
    static let pause = "pause"
    static let seek = "seek"
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
