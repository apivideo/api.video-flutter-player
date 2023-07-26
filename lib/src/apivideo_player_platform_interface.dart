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

  /// Returns [true] if the platform element has been created.
  Future<bool> isCreated(int textureId) {
    throw UnimplementedError('isCreated() has not been implemented.');
  }

  /// Returns whether the video is playing or not
  Future<bool> isPlaying(int textureId) {
    throw UnimplementedError('isPlaying() has not been implemented.');
  }

  /// Returns number of milliseconds from the beginning of the video to the
  /// current time
  Future<int> getCurrentTime(int textureId) {
    throw UnimplementedError('getCurrentTime() has not been implemented.');
  }

  /// Sets the video position to a time in milliseconds from the start.
  Future<void> setCurrentTime(int textureId, int currentTime) {
    throw UnimplementedError('setCurrentTime() has not been implemented.');
  }

  /// Returns the duration of the video
  Future<int> getDuration(int textureId) {
    throw UnimplementedError('getDuration() has not been implemented.');
  }

  /// Returns the current video
  Future<VideoOptions> getVideoOptions(int textureId) {
    throw UnimplementedError('getVideoOptions() has not been implemented.');
  }

  /// Sets the video
  Future<void> setVideoOptions(int textureId, VideoOptions videoOptions) {
    throw UnimplementedError('setVideoOptions() has not been implemented.');
  }

  /// Gets the autoplay state
  Future<bool> getAutoplay(int textureId) {
    throw UnimplementedError('getAutoplay() has not been implemented.');
  }

  /// Sets the autoplay state
  Future<void> setAutoplay(int textureId, bool autoplay) {
    throw UnimplementedError('setAutoplay() has not been implemented.');
  }

  /// Gets the muted state
  Future<bool> getIsMuted(int textureId) {
    throw UnimplementedError('getIsMuted() has not been implemented.');
  }

  /// Sets the muted state
  Future<void> setIsMuted(int textureId, bool isMuted) {
    throw UnimplementedError('setIsMuted() has not been implemented.');
  }

  /// Gets the looping state
  Future<bool> getIsLooping(int textureId) {
    throw UnimplementedError('getIsLooping() has not been implemented.');
  }

  /// Sets the looping state
  Future<void> setIsLooping(int textureId, bool isLooping) async {
    throw UnimplementedError('setIsLooping() has not been implemented.');
  }

  /// Gets the volume
  Future<double> getVolume(int textureId) {
    throw UnimplementedError('getVolume() has not been implemented.');
  }

  /// Sets the volume from 0 to 100.
  Future<void> setVolume(int textureId, double volume) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  /// Gets the video size
  Future<Size?> getVideoSize(int textureId) {
    throw UnimplementedError('getVideoSize() has not been implemented.');
  }

  /// Creates the texture and registers the native events caller.
  /// returns the texture id
  Future<int?> initialize(bool autoplay) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Creates the native player
  Future<void> create(int textureId, VideoOptions videoOptions) {
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

  /// Sets the video position to a time in milliseconds from the current time.
  Future<void> seek(int textureId, int offset) {
    throw UnimplementedError('seek() has not been implemented.');
  }

  Future<void> setPlaybackRate(int textureId, double speedRate) {
    throw UnimplementedError('setPlaybackSpeed() has not been implemented.');
  }

  Future<double> getPlaybackRate(int textureId) {
    throw UnimplementedError('getPlaybackSpeed() has not been implemented.');
  }

  /// Returns a widget displaying the video with a given textureID.
  Widget buildView(int textureId) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  /// Returns a Stream of [PlayerEvent]s.
  Stream<PlayerEvent> playerEventsFor(int textureId) {
    throw UnimplementedError('playerEventsFor() has not been implemented.');
  }
}

class _PlatformImplementation extends ApiVideoPlayerPlatform {}

class PlayerEvent {
  /// Adds optional parameters here if needed

  /// The [PlayerEventType]
  final PlayerEventType type;

  PlayerEvent({required this.type});
}

enum PlayerEventType {
  /// The player is ready.
  ready,

  /// The playback just started.
  played,

  /// The playback has been paused.
  paused,

  /// The video has been seek.
  seek,

  /// The video seek has started.
  seekStarted,

  /// The playback has been ended.
  ended,

  /// An unknown event has been received.
  unknown,
}
