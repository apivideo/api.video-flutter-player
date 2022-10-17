import Foundation

public class FlutterApiVideoPlayerViewFactory: NSObject, FlutterPlatformViewFactory {
    private var binaryMessenger: FlutterBinaryMessenger

       init(binaryMessenger: FlutterBinaryMessenger) {
           self.binaryMessenger = binaryMessenger
           super.init()
       }
    
    public func create(
           withFrame frame: CGRect,
           viewIdentifier viewId: Int64,
           arguments args: Any?
       ) -> FlutterPlatformView {
           return FlutterApiVideoPlayerView(
               frame: frame,
               binaryMessenger: binaryMessenger,
               id: viewId,
               creationParams: (args as? [String: Any]))
       }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}
