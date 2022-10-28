import ApiVideoPlayer
import AVFoundation
import AVKit
import Foundation

class FlutterPlayerView: NSObject, FlutterStreamHandler {
    private let playerTexture = PlayerFlutterTexture()
    private let textureRegistry: FlutterTextureRegistry
    let textureId: Int64!
    private let frameUpdater: FrameUpdater
    private var displayLink: CADisplayLink!
    private let playerController: ApiVideoPlayerController
    private let playerLayer = AVPlayerLayer() // Only use to fix bugs according to flutter video_player plugin

    private let eventChannel: FlutterEventChannel
    private var eventSink: FlutterEventSink?

    private let events = PlayerEvents()

    init(binaryMessenger: FlutterBinaryMessenger,
         textureRegistry: FlutterTextureRegistry,
         videoOptions: VideoOptions? = nil)
    {
        self.textureRegistry = textureRegistry
        playerController = ApiVideoPlayerController(videoOptions: videoOptions, playerLayer: playerLayer, events: events)
        textureId = self.textureRegistry.register(playerTexture)
        frameUpdater = FrameUpdater(textureRegistry: self.textureRegistry, textureId: textureId)
        displayLink = FlutterPlayerView.createDisplayLink(frameUpdater: frameUpdater)

        eventChannel = FlutterEventChannel(name: "video.api.player/events\(String(textureId))", binaryMessenger: binaryMessenger)
        super.init()
        eventChannel.setStreamHandler(self)

        events.didPrepare = {
            self.playerController.addOutput(output: self.playerTexture.videoOutput)
            // Hack to load the first image. We don't need it in case of autoplay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.textureRegistry.textureFrameAvailable(self.textureId)
            }

            self.eventSink?(["type": "ready"])
        }
        events.didPlay = {
            self.eventSink?(["type": "played"])
        }
        events.didPause = {
            self.eventSink?(["type": "paused"])
        }
        events.didSeek = { from, to in
            self.eventSink?(["type": "seek"])
        }
        events.didEnd = {
            self.eventSink?(["type": "ended"])
        }
        events.didError = { error in
            self.eventSink?(FlutterError(code: "error", message: error.localizedDescription, details: error))
        }
    }

    static func createVideoOutput() -> AVPlayerItemVideoOutput {
        let pixBuffAttributes = [kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA),
                                 kCVPixelBufferIOSurfacePropertiesKey: [:]] as [String: Any]
        return AVPlayerItemVideoOutput(pixelBufferAttributes: pixBuffAttributes)
    }

    static func createDisplayLink(frameUpdater: FrameUpdater) -> CADisplayLink {
        let displayLink = CADisplayLink(target: frameUpdater, selector: #selector(FrameUpdater.onDisplayLink(_:)))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        displayLink.isPaused = true
        return displayLink
    }

    var videoOptions: VideoOptions? {
        get {
            playerController.videoOptions
        }
        set {
            playerController.videoOptions = newValue
        }
    }

    var isPlaying: Bool {
        playerController.isPlaying
    }

    var duration: CMTime {
        playerController.duration
    }

    var currentTime: CMTime {
        get {
            playerController.currentTime
        }
        set {
            playerController.seek(to: newValue)
        }
    }

    func play() {
        playerController.play()
        displayLink.isPaused = false
    }

    func pause() {
        playerController.pause()
        displayLink.isPaused = true
    }

    func seek(offset: CMTime) {
        playerController.seek(offset: offset)
        textureRegistry.textureFrameAvailable(textureId) // render frame of the new scene
    }

    func onTextureUnregistered() {
        dispose()
    }

    func dispose() {
        pause()
        playerController.removeOutput(output: playerTexture.videoOutput)
        displayLink.invalidate()
        textureRegistry.unregisterTexture(textureId)
        eventSink?(FlutterEndOfEventStream)
    }

    func onListen(withArguments _: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    func onCancel(withArguments _: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}

class FrameUpdater: NSObject {
    private let textureRegistry: FlutterTextureRegistry
    private let textureId: Int64

    init(textureRegistry: FlutterTextureRegistry, textureId: Int64) {
        self.textureRegistry = textureRegistry
        self.textureId = textureId
    }

    @objc func onDisplayLink(_: CADisplayLink) {
        textureRegistry.textureFrameAvailable(textureId)
    }
}

class PlayerFlutterTexture: NSObject, FlutterTexture {
    let videoOutput = FlutterPlayerView.createVideoOutput()

    func copyPixelBuffer() -> Unmanaged<CVPixelBuffer>? {
        let outputItemTime = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        if videoOutput.hasNewPixelBuffer(forItemTime: outputItemTime) {
            guard let pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: outputItemTime, itemTimeForDisplay: nil) else {
                return nil
            }
            return Unmanaged<CVPixelBuffer>.passRetained(pixelBuffer)
        } else {
            return nil
        }
    }
}
