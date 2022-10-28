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

    func initialize() -> Int64 {
        let player = FlutterPlayerView(binaryMessenger: binaryMessenger, textureRegistry: textureRegistry)

        players[player.textureId] = player

        return player.textureId
    }

    func create(textureId: Int64, videoOptions: VideoOptions) {
        guard let player = players[textureId] else {
            print("Unknown player \(textureId)")
            return
        }
        player.videoOptions = videoOptions
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
}

extension Int {
    func msToCMTime() -> CMTime {
        return CMTime(value: CMTimeValue(self), timescale: 1000)
    }
}

extension CMTime {
    func toMs() -> Int {
        return Int(seconds * 1000)
    }
}
