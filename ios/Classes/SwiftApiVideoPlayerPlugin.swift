import Flutter
import UIKit

public class SwiftApiVideoPlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      let factory = FlutterApiVideoPlayerViewFactory(binaryMessenger: registrar.messenger())
            registrar.register(factory, withId: "plugins.video.api/flutter_player_view")
  }
}
