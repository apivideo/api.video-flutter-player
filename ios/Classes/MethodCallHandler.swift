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
                case Keys.isCreated:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isCreated": self?.controller.isCreated(textureId: Int64(textureId))])
                case Keys.initialize:
                    guard let args = call.arguments as? [String: Any],
                          let autoplay = args["autoplay"] as? Bool
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    let textureId = self?.controller.initialize(autoplay: autoplay)
                    result([Keys.textureId: textureId])
                case Keys.dispose:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.dispose(textureId: Int64(textureId))
                    result(nil)
                case Keys.isPlaying:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isPlaying": self?.controller.isPlaying(textureId: Int64(textureId))])
                case Keys.isLive:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isLive": self?.controller.isLive(textureId: Int64(textureId))])
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
                    result(nil)
                case Keys.getDuration:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["duration": self?.controller.getDuration(textureId: Int64(textureId))])
                case Keys.getVideoOptions:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    let videoOptions = self?.controller.getVideoOptions(textureId: Int64(textureId)) // As it is mandatory to set a video option. This should never be null.
                    result(videoOptions?.toMap())
                case Keys.setVideoOptions:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let videoOptions = args["videoOptions"] as? [String: Any]
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or video options", details: nil))
                        return
                    }
                    self?.controller.setVideoOptions(textureId: Int64(textureId), videoOptions: videoOptions.toVideoOptions())
                    result(nil)
                case Keys.getAutoplay:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["autoplay": self?.controller.getAutoplay(textureId: Int64(textureId))])
                case Keys.setAutoplay:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let autoplay = args["autoplay"] as? Bool
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or autoplay", details: nil))
                        return
                    }
                    self?.controller.setAutoplay(textureId: Int64(textureId), autoplay: autoplay)
                    result(nil)
                case Keys.getIsMuted:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isMuted": self?.controller.getIsMuted(textureId: Int64(textureId))])
                case Keys.setIsMuted:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let isMuted = args["isMuted"] as? Bool
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or is muted", details: nil))
                        return
                    }
                    self?.controller.setIsMuted(textureId: Int64(textureId), isMuted: isMuted)
                    result(nil)
                case Keys.getIsLooping:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["isLooping": self?.controller.getIsLooping(textureId: Int64(textureId))])
                case Keys.setIsLooping:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let isLooping = args["isLooping"] as? Bool
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or is looping", details: nil))
                        return
                    }
                    self?.controller.setIsLooping(textureId: Int64(textureId), isLooping: isLooping)
                    result(nil)
                case Keys.getVolume:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["volume": self?.controller.getVolume(textureId: Int64(textureId))])
                case Keys.setVolume:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let volume = args["volume"] as? Double
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or volume", details: nil))
                        return
                    }
                    self?.controller.setVolume(textureId: Int64(textureId), volume: Float(volume))
                case Keys.getVideoSize:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    guard let videoSize = self?.controller.getVideoSize(textureId: Int64(textureId)) else {
                        result([String: Any]())
                        return
                    }
                    result(["width": videoSize.width, "height": videoSize.height])
                case Keys.play:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.play(textureId: Int64(textureId))
                    result(nil)
                case Keys.pause:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    self?.controller.pause(textureId: Int64(textureId))
                    result(nil)
                case Keys.seek:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let offset = args["offset"] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or offset", details: nil))
                        return
                    }
                    self?.controller.seek(textureId: Int64(textureId), offset: offset)
                    result(nil)
                case Keys.setPlaybackSpeed:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int,
                          let speed = args["speedRate"] as? Double
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id or speed", details: nil))
                        return
                    }
                    self?.controller.setPlaybackSpeed(textureId: Int64(textureId), speedRate: speed)
                    result(nil)
                case Keys.getPlaybackSpeed:
                    guard let args = call.arguments as? [String: Any],
                          let textureId = args[Keys.textureId] as? Int
                    else {
                        result(FlutterError(code: "invalid_parameter", message: "Failed to get texture id", details: nil))
                        return
                    }
                    result(["speedRate": self?.controller.getPlaybackSpeed(textureId: Int64(textureId))])
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
    static let textureId = "textureId"

    static let vod = "vod"
    static let live = "live"

    static let isCreated = "isCreated"
    static let initialize = "initialize"
    static let dispose = "dispose"

    static let isPlaying = "isPlaying"
    static let isLive = "isLive"
    static let getCurrentTime = "getCurrentTime"
    static let setCurrentTime = "setCurrentTime"
    static let getDuration = "getDuration"
    static let getVideoOptions = "getVideoOptions"
    static let setVideoOptions = "setVideoOptions"
    static let getAutoplay = "getAutoplay"
    static let setAutoplay = "setAutoplay"
    static let getIsMuted = "getIsMuted"
    static let setIsMuted = "setIsMuted"
    static let getIsLooping = "getIsLooping"
    static let setIsLooping = "setIsLooping"
    static let getVolume = "getVolume"
    static let setVolume = "setVolume"
    static let getVideoSize = "getVideoSize"
    static let getPlaybackSpeed = "getPlaybackSpeed"
    static let setPlaybackSpeed = "setPlaybackSpeed"

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

extension VideoType {
    func toString() -> String {
        switch self {
        case VideoType.vod:
            return Keys.vod
        case VideoType.live:
            return Keys.live
        }
    }
}

extension Dictionary where Key == String {
    func toVideoOptions() -> VideoOptions {
        return VideoOptions(videoId: self["videoId"] as! String, videoType: (self["type"] as! String).toVideoType(), token: self["token"] as? String)
    }
}

extension VideoOptions {
    func toMap() -> [String: Any?] {
        return [
            "videoId": videoId,
            "type": videoType.toString(),
            "token": token ?? nil,
        ]
    }
}
