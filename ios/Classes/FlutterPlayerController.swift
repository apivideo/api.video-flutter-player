import ApiVideoPlayer
import Foundation

// Manages a list of multiple players
class FlutterPlayerController {
    private let binaryMessenger: FlutterBinaryMessenger
    private let textureRegistry: FlutterTextureRegistry
    private var players: [Int64: FlutterPlayerView] = [:]

    init(binaryMessenger: FlutterBinaryMessenger, textureRegistry: FlutterTextureRegistry) {
        self.binaryMessenger = binaryMessenger
        self.textureRegistry = textureRegistry
    }

    func isCreated(textureId: Int64) -> Bool {
        return players[textureId] != nil
    }

    func initialize(autoplay: Bool) -> Int64 {
        let player = FlutterPlayerView(binaryMessenger: binaryMessenger, textureRegistry: textureRegistry, autoplay: autoplay)

        players[player.textureId] = player

        return player.textureId
    }

    func dispose(textureId: Int64) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.dispose()
        players.removeValue(forKey: textureId)
    }

    func disposeAll() {
        for player in players.values {
            player.dispose()
        }
        players.removeAll()
    }

    func isPlaying(textureId: Int64) -> Bool {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return false
        }
        return player.isPlaying
    }

    func isLive(textureId: Int64) -> Bool {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return false
        }
        return player.isLive
    }

    func getCurrentTime(textureId: Int64) -> Int {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return 0
        }
        return player.currentTime.toMs()
    }

    func setCurrentTime(textureId: Int64, currentTime: Int) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.currentTime = currentTime.msToCMTime()
    }

    func getDuration(textureId: Int64) -> Int {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return 0
        }
        return player.duration.toMs()
    }

    func getVideoOptions(textureId: Int64) -> VideoOptions? {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return nil
        }
        return player.videoOptions
    }

    func setVideoOptions(textureId: Int64, videoOptions: VideoOptions) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.videoOptions = videoOptions
    }

    func getAutoplay(textureId: Int64) -> Bool {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return false
        }
        return player.autoplay
    }

    func setAutoplay(textureId: Int64, autoplay: Bool) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.autoplay = autoplay
    }

    func getIsMuted(textureId: Int64) -> Bool {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return false
        }
        return player.isMuted
    }

    func setIsMuted(textureId: Int64, isMuted: Bool) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.isMuted = isMuted
    }

    func getIsLooping(textureId: Int64) -> Bool {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return false
        }
        return player.isLooping
    }

    func setIsLooping(textureId: Int64, isLooping: Bool) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.isLooping = isLooping
    }

    func getVolume(textureId: Int64) -> Float {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return 0
        }
        return player.volume
    }

    func setVolume(textureId: Int64, volume: Float) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.volume = volume
    }

    func getVideoSize(textureId: Int64) -> CGSize? {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return nil
        }
        return player.videoSize
    }

    func play(textureId: Int64) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.play()
    }

    func pause(textureId: Int64) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.pause()
    }

    func seek(textureId: Int64, offset: Int) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.seek(offset: offset.msToCMTime())
    }

    func setPlaybackSpeed(textureId: Int64, speedRate: Double) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.speedRate = Float(speedRate)
    }

    func getPlaybackSpeed(textureId: Int64) -> Double {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return 0
        }
        return Double(player.speedRate)
    }
}

extension Int {
    func msToCMTime() -> CMTime {
        return CMTime(value: CMTimeValue(self), timescale: 1000)
    }
}

extension CMTime {
    func toMs() -> Int {
        let seconds = self.seconds
        guard !(seconds.isNaN || seconds.isInfinite) else {
            return 0
        }
        return Int(seconds * 1000)
    }
}
