import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';

/// An implementation of [ApiVideoPlayerPlatform] that uses method channels.
class MethodChannelApiVideoPlayer extends ApiVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apivideo_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
