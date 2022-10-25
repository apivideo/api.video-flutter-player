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

    func create(videoId: String, videoType: VideoType) -> Int64 {
        let player = FlutterPlayerView(frame: .zero, binaryMessenger: binaryMessenger, textureRegistry: textureRegistry, videoId: videoId, videoType: videoType)

        players[player.textureId] = player

        return player.textureId
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
}
