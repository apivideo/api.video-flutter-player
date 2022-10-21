import 'package:apivideo_player/src/apivideo_types.dart';
import 'package:flutter/cupertino.dart';

import 'apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

class ApiVideoPlayerController {
  VideoOptions videoOptions;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  /// This is just exposed for testing. Do not use it.
  @visibleForTesting
  int get textureId => _textureId;

  ApiVideoPlayerController(this.videoOptions);

  Future<void> initialize() async {
    _textureId =
        await _playerPlatform.create(videoOptions) ?? kUninitializedTextureId;

    return;
  }

  Future<void> play() async {
    return _playerPlatform.play(_textureId);
  }

  Future<void> pause() async {
    return _playerPlatform.pause(_textureId);
  }

  Future<void> dispose() async {
    return _playerPlatform.dispose(_textureId);
  }
}
