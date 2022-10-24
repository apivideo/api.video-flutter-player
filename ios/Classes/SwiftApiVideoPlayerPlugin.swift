import Flutter
import UIKit

public class SwiftApiVideoPlayerPlugin: NSObject, FlutterPlugin {
    private var textureRegistry: FlutterTextureRegistry!
    private var messenger: FlutterBinaryMessenger!
    private var api: MethodCallHandler!

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftApiVideoPlayerPlugin(registrar: registrar)
        registrar.publish(instance)
    }

    init(registrar: FlutterPluginRegistrar) {
        textureRegistry = registrar.textures()
        messenger = registrar.messenger()
        api = MethodCallHandler(binaryMessenger: messenger, controller: FlutterPlayerController(binaryMessenger: messenger, textureRegistry: textureRegistry))
    }

    public func detachFromEngine(for _: FlutterPluginRegistrar) {
        api.dispose()
    }
}
