import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apivideo_player_method_channel.dart';

abstract class ApiVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a ApiVideoPlayerPlatform.
  ApiVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApiVideoPlayerPlatform _instance = MethodChannelApiVideoPlayer();

  /// The default instance of [ApiVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelApiVideoPlayer].
  static ApiVideoPlayerPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApiVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(ApiVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
