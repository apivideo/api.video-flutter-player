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

    init(binaryMessenger: FlutterBinaryMessenger,
         textureRegistry: FlutterTextureRegistry,
         videoOptions: VideoOptions? = nil,
         autoplay: Bool)
    {
        self.textureRegistry = textureRegistry
        playerController = ApiVideoPlayerController(videoOptions: videoOptions,playerLayer: playerLayer, autoplay: autoplay)
        textureId = self.textureRegistry.register(playerTexture)
        frameUpdater = FrameUpdater(textureRegistry: self.textureRegistry, textureId: textureId)
        displayLink = FlutterPlayerView.createDisplayLink(frameUpdater: frameUpdater)
        eventChannel = FlutterEventChannel(name: "video.api.player/events\(String(textureId))", binaryMessenger: binaryMessenger)
        super.init()
        eventChannel.setStreamHandler(self)
        self.playerController.addDelegate(delegate: self)
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
            self.eventSink?(["type": "seekStarted"])
            playerController.seek(to: newValue)
        }
    }

    var autoplay: Bool {
        get {
            playerController.autoplay
        }
        set {
            playerController.autoplay = newValue
        }
    }

    var isMuted: Bool {
        get {
            playerController.isMuted
        }
        set {
            playerController.isMuted = newValue
        }
    }

    var volume: Float {
        get {
            playerController.volume
        }
        set {
            playerController.volume = newValue
        }
    }

    var isLooping: Bool {
        get {
            playerController.isLooping
        }
        set {
            playerController.isLooping = newValue
        }
    }

    var videoSize: CGSize? {
        let videoSize = playerController.videoSize
        if videoSize.width != 0, videoSize.height != 0 {
            return videoSize
        } else {
            return nil
        }
    }

    func play() {
        playerController.play()
    }

    func pause() {
        playerController.pause()
    }

    func seek(offset: CMTime) {
        self.eventSink?(["type": "seekStarted"])
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

extension FlutterPlayerView: ApiVideoPlayerControllerPlayerDelegate{
    func didPrepare() {
    }
    
    func didReady() {
        self.playerController.addOutput(output: self.playerTexture.videoOutput)
        // Hack to load the first image. We don't need it in case of autoplay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.textureRegistry.textureFrameAvailable(self.textureId)
        }

        self.eventSink?(["type": "ready"])
    }
    
    func didPause() {
        self.displayLink.isPaused = true
        self.eventSink?(["type": "paused"])
    }
    
    func didPlay() {
        self.displayLink.isPaused = false
        self.eventSink?(["type": "played"])
    }
    
    func didReplay() {
        
    }
    
    func didMute() {
        
    }
    
    func didUnMute() {
        
    }
    
    func didLoop() {
        
    }
    
    func didSetVolume(_ volume: Float) {
        
    }
    
    func didSeek(_ from: CMTime, _ to: CMTime) {
        self.eventSink?(["type": "seek"])
    }
    
    func didEnd() {
        self.displayLink.isPaused = true
        self.eventSink?(["type": "ended"])
    }
    
    func didError(_ error: Error) {
        if(videoOptions?.token != nil){
            self.eventSink?(FlutterError(code: "error", message: error.localizedDescription, details: "The videoId or token may be wrong"))
        } else{
            self.eventSink?(FlutterError(code: "error", message: error.localizedDescription, details: "The videoId may be wrong"))
        }
        
    }
    
    func didVideoSizeChanged(_ size: CGSize) {
        
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
