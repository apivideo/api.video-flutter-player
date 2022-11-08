import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/apivideo_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

class ApiVideoPlayerController {
  final VideoOptions _initialVideoOptions;
  final bool _initialAutoplay;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  StreamSubscription<dynamic>? _eventSubscription;
  List<ApiVideoPlayerEventsListener> eventsListeners = [];
  List<ApiVideoPlayerWidgetListener> widgetListeners = [];

  /// This is just exposed for testing. Do not use it.
  @visibleForTesting
  int get textureId => _textureId;

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
    eventsListeners.add(ApiVideoPlayerEventsListener(
        onReady: onReady,
        onPlay: onPlay,
        onPause: onPause,
        onEnd: onEnd,
        onError: onError));
  }

  ApiVideoPlayerController.fromListener(
      {required VideoOptions videoOptions,
      bool autoplay = false,
      ApiVideoPlayerEventsListener? listener})
      : _initialAutoplay = autoplay,
        _initialVideoOptions = videoOptions {
    if (listener != null) {
      eventsListeners.add(listener);
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
    _textureId = await _playerPlatform.initialize(_initialAutoplay) ??
        kUninitializedTextureId;

    _eventSubscription = _playerPlatform
        .playerEventsFor(_textureId)
        .listen(_eventListener, onError: _errorListener);

    await _playerPlatform.create(_textureId, _initialVideoOptions);

     for (var listener in [...widgetListeners]) {
      if (listener.onTextureReady != null) {
        listener.onTextureReady!();
      }
    }

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
    eventsListeners.clear();
    await _playerPlatform.dispose(_textureId);
    return;
  }

  Future<void> seek(Duration offset) {
    return _playerPlatform.seek(_textureId, offset.inMilliseconds);
  }

  void addEventsListener(ApiVideoPlayerEventsListener listener) {
    eventsListeners.add(listener);
  }

  void removeEventsListener(ApiVideoPlayerEventsListener listener) {
    eventsListeners.remove(listener);
  }

  /// This is exposed for internal use only. Do not use it.
  @visibleForTesting
  void addWidgetListener(ApiVideoPlayerWidgetListener listener) {
    widgetListeners.add(listener);
  }

  /// This is exposed for internal use only. Do not use it.
  @visibleForTesting
  void removeWidgetListener(ApiVideoPlayerWidgetListener listener) {
    widgetListeners.remove(listener);
  }

  void _errorListener(Object obj) {
    final PlatformException e = obj as PlatformException;
    for (var listener in [...eventsListeners]) {
      if (listener.onError != null) {
        listener.onError!(e);
      }
    }
  }

  void _eventListener(PlayerEvent event) {
    switch (event.type) {
      case PlayerEventType.ready:
        for (var listener in [...eventsListeners]) {
          if (listener.onReady != null) {
            listener.onReady!();
          }
        }
        break;
      case PlayerEventType.played:
        for (var listener in [...eventsListeners]) {
          if (listener.onPlay != null) {
            listener.onPlay!();
          }
        }
        break;
      case PlayerEventType.paused:
        for (var listener in [...eventsListeners]) {
          if (listener.onPause != null) {
            listener.onPause!();
          }
        }
        break;
      case PlayerEventType.seek:
        for (var listener in [...eventsListeners]) {
          if (listener.onSeek != null) {
            listener.onSeek!();
          }
        }
        break;
      case PlayerEventType.ended:
        for (var listener in [...eventsListeners]) {
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

class ApiVideoPlayerEventsListener {
  final VoidCallback? onReady;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onSeek;
  final VoidCallback? onEnd;
  final Function(Object)? onError;

  ApiVideoPlayerEventsListener(
      {this.onReady,
      this.onPlay,
      this.onPause,
      this.onSeek,
      this.onEnd,
      this.onError});
}

class ApiVideoPlayerWidgetListener {
  final VoidCallback? onTextureReady;

  ApiVideoPlayerWidgetListener({this.onTextureReady});
}
