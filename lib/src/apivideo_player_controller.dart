import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/apivideo_player_life_cycle_observer.dart';
import 'package:apivideo_player/src/apivideo_types.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'platform/apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

class ApiVideoPlayerController {
  final VideoOptions _initialVideoOptions;
  final bool _initialAutoplay;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  StreamSubscription<dynamic>? _eventSubscription;
  final List<ApiVideoPlayerControllerEventsListener> _eventsListeners = [];
  final List<ApiVideoPlayerControllerWidgetListener> _widgetListeners = [];

  PlayerLifeCycleObserver? _lifeCycleObserver;

  /// This is just exposed for testing. Do not use it.
  @internal
  int get textureId => _textureId;

  /// Creates a new controller where each event callbacks are set explicitly.
  ApiVideoPlayerController({
    required VideoOptions videoOptions,
    bool autoplay = false,
    VoidCallback? onReady,
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onEnd,
    Function(Object)? onError,
  })  : _initialAutoplay = autoplay,
        _initialVideoOptions = videoOptions {
    _eventsListeners.add(ApiVideoPlayerControllerEventsListener(
        onReady: onReady,
        onPlay: onPlay,
        onPause: onPause,
        onEnd: onEnd,
        onError: onError));
  }

  /// Creates a new controller with a [ApiVideoPlayerControllerEventsListener].
  ApiVideoPlayerController.fromListener(
      {required VideoOptions videoOptions,
      bool autoplay = false,
      ApiVideoPlayerControllerEventsListener? listener})
      : _initialAutoplay = autoplay,
        _initialVideoOptions = videoOptions {
    if (listener != null) {
      _eventsListeners.add(listener);
    }
  }

  /// Whether the controller has been created.
  Future<bool> get isCreated => _playerPlatform.isCreated(_textureId);

  /// Whether the video is playing.
  Future<bool> get isPlaying {
    return _playerPlatform.isPlaying(_textureId);
  }

  /// Whether the current video is a live.
  Future<bool> get isLive async {
    return await _playerPlatform.isLive(_textureId);
  }

  /// The video current time.
  Future<Duration> get currentTime async {
    final milliseconds = await _playerPlatform.getCurrentTime(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  /// Sets the current playback time.
  Future<void> setCurrentTime(Duration currentTime) {
    return _playerPlatform.setCurrentTime(
        _textureId, currentTime.inMilliseconds);
  }

  /// The duration of the video.
  Future<Duration> get duration async {
    final milliseconds = await _playerPlatform.getDuration(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  /// The current video options.
  Future<VideoOptions> get videoOptions {
    return _playerPlatform.getVideoOptions(_textureId);
  }

  /// Sets the video options to play a new video.
  Future<void> setVideoOptions(VideoOptions videoOptions) {
    return _playerPlatform.setVideoOptions(_textureId, videoOptions);
  }

  /// Whether the video will be play automatically.
  Future<bool> get autoplay {
    return _playerPlatform.getAutoplay(_textureId);
  }

  /// Sets if the video will be play automatically.
  Future<void> setAutoplay(bool autoplay) {
    return _playerPlatform.setAutoplay(_textureId, autoplay);
  }

  /// Whether the video is muted.
  Future<bool> get isMuted {
    return _playerPlatform.getIsMuted(_textureId);
  }

  /// Mutes/unmutes the video.
  Future<void> setIsMuted(bool isMuted) {
    return _playerPlatform.setIsMuted(_textureId, isMuted);
  }

  /// Whether the video is in loop mode.
  Future<bool> get isLooping {
    return _playerPlatform.getIsLooping(_textureId);
  }

  /// Sets if the video should be played in loop.
  Future<void> setIsLooping(bool isLooping) {
    return _playerPlatform.setIsLooping(_textureId, isLooping);
  }

  /// The current audio volume
  Future<double> get volume {
    return _playerPlatform.getVolume(_textureId);
  }

  /// Sets the audio volume.
  ///
  /// From 0 to 1 (0 = muted, 1 = 100%).
  Future<void> setVolume(double volume) {
    if (volume < 0 || volume > 1) {
      throw ArgumentError('Volume must be between 0 and 1');
    }
    return _playerPlatform.setVolume(_textureId, volume);
  }

  /// The playback speed rate.
  Future<double> get speedRate {
    return _playerPlatform.getPlaybackRate(_textureId);
  }

  /// Sets the playback speed rate.
  ///
  /// We recommend to set the value from 0.5 to 2 (0.5 = 50%, 2 = 200%).
  Future<void> setSpeedRate(double speedRate) {
    return _playerPlatform.setPlaybackRate(_textureId, speedRate);
  }

  /// The current video size.
  Future<Size?> get videoSize {
    return _playerPlatform.getVideoSize(_textureId);
  }

  /// Initializes the controller.
  Future<void> initialize() async {
    _textureId = await _playerPlatform.initialize(_initialAutoplay) ??
        kUninitializedTextureId;

    _lifeCycleObserver = PlayerLifeCycleObserver(this);
    _lifeCycleObserver?.initialize();

    _eventSubscription = _playerPlatform
        .playerEventsFor(_textureId)
        .listen(_eventListener, onError: _errorListener);

    await _playerPlatform.create(_textureId, _initialVideoOptions);

    for (var listener in [..._widgetListeners]) {
      if (listener.onTextureReady != null) {
        listener.onTextureReady!();
      }
    }

    return;
  }

  /// Plays the video.
  Future<void> play() {
    return _playerPlatform.play(_textureId);
  }

  /// Pauses the video.
  Future<void> pause() {
    return _playerPlatform.pause(_textureId);
  }

  /// Disposes the controller.
  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    _eventsListeners.clear();
    await _playerPlatform.dispose(_textureId);
    _lifeCycleObserver?.dispose();
    return;
  }

  /// Adds/substracts the given Duration to/from the playback time.
  Future<void> seek(Duration offset) {
    return _playerPlatform.seek(_textureId, offset.inMilliseconds);
  }

  /// Adds an event listener to this controller.
  ///
  /// ```dart
  /// final ApiVideoPlayerControllerEventsListener _eventsListener =
  ///    ApiVideoPlayerControllerEventsListener(onPlay: () => print('PLAY'));
  ///
  /// controller.addEventsListener(_eventsListener);
  /// ```
  void addListener(ApiVideoPlayerControllerEventsListener listener) {
    _eventsListeners.add(listener);
  }

  /// Adds an event listener to this controller.
  ///
  /// ```dart
  /// final ApiVideoPlayerControllerEventsListener _eventsListener =
  ///    ApiVideoPlayerControllerEventsListener(onPlay: () => print('PLAY'));
  ///
  /// controller.removeEventsListener(_eventsListener);
  /// ```
  void removeListener(ApiVideoPlayerControllerEventsListener listener) {
    _eventsListeners.remove(listener);
  }

  /// Internal use only. Do not use it.
  @internal
  void addWidgetListener(ApiVideoPlayerControllerWidgetListener listener) {
    _widgetListeners.add(listener);
  }

  /// Internal use only. Do not use it.
  @internal
  void removeWidgetListener(ApiVideoPlayerControllerWidgetListener listener) {
    _widgetListeners.remove(listener);
  }

  void _errorListener(Object obj) {
    final PlatformException e = obj as PlatformException;
    for (var listener in [..._eventsListeners]) {
      if (listener.onError != null) {
        listener.onError!(e);
      }
    }
  }

  void _eventListener(PlayerEvent event) {
    switch (event.type) {
      case PlayerEventType.ready:
        for (var listener in [..._eventsListeners]) {
          if (listener.onReady != null) {
            listener.onReady!();
          }
        }
        break;
      case PlayerEventType.played:
        for (var listener in [..._eventsListeners]) {
          if (listener.onPlay != null) {
            listener.onPlay!();
          }
        }
        break;
      case PlayerEventType.paused:
        for (var listener in [..._eventsListeners]) {
          if (listener.onPause != null) {
            listener.onPause!();
          }
        }
        break;
      case PlayerEventType.seek:
        for (var listener in [..._eventsListeners]) {
          if (listener.onSeek != null) {
            listener.onSeek!();
          }
        }
        break;
      case PlayerEventType.seekStarted:
        for (var listener in [..._eventsListeners]) {
          if (listener.onSeekStarted != null) {
            listener.onSeekStarted!();
          }
        }
        break;
      case PlayerEventType.ended:
        for (var listener in [..._eventsListeners]) {
          if (listener.onEnd != null) {
            listener.onEnd!();
          }
        }
        break;
      case PlayerEventType.unknown:
        // Nothing to do
        break;
    }
  }
}

/// The controller events listener.
/// Use this to listen to the player events.
class ApiVideoPlayerControllerEventsListener {
  final VoidCallback? onReady;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onSeek;
  final VoidCallback? onSeekStarted;
  final VoidCallback? onEnd;
  final Function(Object)? onError;

  ApiVideoPlayerControllerEventsListener(
      {this.onReady,
      this.onPlay,
      this.onPause,
      this.onSeek,
      this.onSeekStarted,
      this.onEnd,
      this.onError});
}

/// The internal controller widget listener.
/// Uses by the [ApiVideoPlayerController] to notify the widget when the texture is ready.
/// Only to be used in the Widget that hold the video such as [ApiVideoPlayerVideo].
class ApiVideoPlayerControllerWidgetListener {
  final VoidCallback? onTextureReady;

  ApiVideoPlayerControllerWidgetListener({this.onTextureReady});
}
