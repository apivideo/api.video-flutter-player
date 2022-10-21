import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';
import 'apivideo_types.dart';

class ApiVideoMobilePlayer extends ApiVideoPlayerPlatform {
  final MethodChannel methodChannel =
      const MethodChannel('video.api.player/controller');

  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith() {
    ApiVideoPlayerPlatform.instance = ApiVideoMobilePlayer();
  }

  @override
  Future<int?> create(VideoOptions videoOptions) {
    // TODO
    throw UnimplementedError('create() has not been implemented.');
  }

  @override
  Future<void> dispose(int textureId) {
    // TODO
    throw UnimplementedError('dispose() has not been implemented.');
  }

  @override
  Future<void> play(int textureId) {
    // TODO
    throw UnimplementedError('play() has not been implemented.');
  }

  @override
  Future<void> pause(int textureId) {
    // TODO
    throw UnimplementedError('pause() has not been implemented.');
  }

  @override
  Widget buildView(int textureId) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}
