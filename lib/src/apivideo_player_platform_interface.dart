import 'package:flutter/cupertino.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apivideo_types.dart';

abstract class ApiVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a ApiVideoPlayerPlatform.
  ApiVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApiVideoPlayerPlatform _instance = _PlatformImplementation();

  /// The default instance of [ApiVideoPlayerPlatform] to use.
  ///
  /// Defaults to [_PlatformImplementation].
  static ApiVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApiVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(ApiVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns wether the video is playing or not
  Future<bool> isPlaying(int textureId) {
    throw UnimplementedError('isPlaying() has not been implemented.');
  }

  /// Return number of milliseconds from the beginning of the video to the
  /// current time
  Future<int> getCurrentTime(int textureId) {
    throw UnimplementedError('getCurrentTime() has not been implemented.');
  }

  /// Return the duration of the video
  Future<Duration> getDuration(int textureId) {
    throw UnimplementedError('getDuration() has not been implemented.');
  }

  /// Creates the native player and returns the textureId
  Future<int?> create(VideoOptions videoOptions) {
    throw UnimplementedError('create() has not been implemented.');
  }

  /// Releases the video player.
  Future<void> dispose(int textureId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Starts the video playback.
  Future<void> play(int textureId) {
    throw UnimplementedError('play() has not been implemented.');
  }

  /// Stops the video playback.
  Future<void> pause(int textureId) {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Sets the video position to a [Duration] from the start.
  Future<void> seek(int textureId, Duration position) {
    throw UnimplementedError('seek() has not been implemented.');
  }

  /// Returns a widget displaying the video with a given textureID.
  Widget buildView(int textureId) {
    throw UnimplementedError('buildView() has not been implemented.');
  }
}

class _PlatformImplementation extends ApiVideoPlayerPlatform {}
