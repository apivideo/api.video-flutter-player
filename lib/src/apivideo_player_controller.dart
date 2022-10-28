import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/apivideo_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

class ApiVideoPlayerController {
  VideoOptions _initialVideoOptions;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  StreamSubscription<dynamic>? _eventSubscription;
  List<ApiVideoPlayerControllerListener> listeners = [];

  /// This is just exposed for testing. Do not use it.
  @visibleForTesting
  int get textureId => _textureId;

  ApiVideoPlayerController({
    required VideoOptions videoOptions,
    VoidCallback? onReady,
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onEnd,
    Function(Object)? onError,
  }) : _initialVideoOptions = videoOptions {
    listeners.add(ApiVideoPlayerControllerListener(
        onReady: onReady,
        onPlay: onPlay,
        onPause: onPause,
        onEnd: onEnd,
        onError: onError));
  }

  ApiVideoPlayerController.fromListener(
      {required VideoOptions videoOptions,
      ApiVideoPlayerControllerListener? listener})
      : _initialVideoOptions = videoOptions {
    if (listener != null) {
      listeners.add(listener);
    }
  }

  Future<bool> get isPlaying {
    return _playerPlatform.isPlaying(_textureId);
  }

  Future<Duration> get currentTime async {
    final milliseconds = await _playerPlatform.getCurrentTime(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  Future<void> setCurrentTime(Duration currentTime) {
    return _playerPlatform.setCurrentTime(
        _textureId, currentTime.inMilliseconds);
  }

  Future<Duration> get duration async {
    final milliseconds = await _playerPlatform.getDuration(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  Future<VideoOptions> get videoOptions {
    return _playerPlatform.getVideoOptions(_textureId);
  }

  Future<void> setVideoOptions(VideoOptions videoOptions) {
    return _playerPlatform.setVideoOptions(_textureId, videoOptions);
  }

  Future<bool> get autoplay {
    return _playerPlatform.getAutoplay(_textureId);
  }

  Future<void> setAutoplay(bool autoplay) {
    return _playerPlatform.setAutoplay(_textureId, autoplay);
  }

  Future<bool> get isMuted {
    return _playerPlatform.getIsMuted(_textureId);
  }

  Future<void> setIsMuted(bool isMuted) {
    return _playerPlatform.setIsMuted(_textureId, isMuted);
  }

  Future<bool> get isLooping {
    return _playerPlatform.getIsLooping(_textureId);
  }

  Future<void> setIsLooping(bool isLooping) {
    return _playerPlatform.setIsLooping(_textureId, isLooping);
  }

  Future<double> get volume {
    return _playerPlatform.getVolume(_textureId);
  }

  Future<void> setVolume(double volume) {
    if (volume < 0 || volume > 100) {
      throw ArgumentError('Volume must be between 0 and 100');
    }
    return _playerPlatform.setVolume(_textureId, volume);
  }

  Future<void> initialize() async {
    _textureId = await _playerPlatform.initialize() ?? kUninitializedTextureId;

    _eventSubscription = _playerPlatform
        .playerEventsFor(_textureId)
        .listen(_eventListener, onError: _errorListener);

    await _playerPlatform.create(_textureId, _initialVideoOptions);

    return;
  }

  Future<void> play() {
    return _playerPlatform.play(_textureId);
  }

  Future<void> pause() {
    return _playerPlatform.pause(_textureId);
  }

  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    listeners.clear();
    await _playerPlatform.dispose(_textureId);
    return;
  }

  Future<void> seek(Duration offset) {
    return _playerPlatform.seek(_textureId, offset.inMilliseconds);
  }

  void addListener(ApiVideoPlayerControllerListener listener) {
    listeners.add(listener);
  }

  void removeListener(ApiVideoPlayerControllerListener listener) {
    listeners.remove(listener);
  }

  void _errorListener(Object obj) {
    final PlatformException e = obj as PlatformException;
    for (var listener in [...listeners]) {
      if (listener.onError != null) {
        listener.onError!(e);
      }
    }
  }

  void _eventListener(PlayerEvent event) {
    switch (event.type) {
      case PlayerEventType.ready:
        for (var listener in [...listeners]) {
          if (listener.onReady != null) {
            listener.onReady!();
          }
        }
        break;
      case PlayerEventType.played:
        for (var listener in [...listeners]) {
          if (listener.onPlay != null) {
            listener.onPlay!();
          }
        }
        break;
      case PlayerEventType.paused:
        for (var listener in [...listeners]) {
          if (listener.onPause != null) {
            listener.onPause!();
          }
        }
        break;
      case PlayerEventType.seek:
        for (var listener in [...listeners]) {
          if (listener.onSeek != null) {
            listener.onSeek!();
          }
        }
        break;
      case PlayerEventType.ended:
        for (var listener in [...listeners]) {
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

class ApiVideoPlayerControllerListener {
  final VoidCallback? onReady;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onSeek;
  final VoidCallback? onEnd;
  final Function(Object)? onError;

  ApiVideoPlayerControllerListener(
      {this.onReady,
      this.onPlay,
      this.onPause,
      this.onSeek,
      this.onEnd,
      this.onError});
}
