import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';

/// An implementation of [ApiVideoPlayerPlatform] that uses method channels.
class ApiVideoPlayerController extends ApiVideoPlayerControllerInterface {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel;

  ApiVideoPlayerController(this.methodChannel);

  ApiVideoPlayerController.withId(int id)
      : this(MethodChannel('plugins.video.api/apivideo_player_$id'));

  @override
  Future<void> play() async {
    return methodChannel.invokeMethod<void>('play');
  }

  @override
  Future<void> pause() async {
    return methodChannel.invokeMethod<void>('pause');
  }
}
