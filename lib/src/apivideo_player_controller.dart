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
  VideoOptions videoOptions;

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;

  StreamSubscription<dynamic>? _eventSubscription;
  List<ApiVideoPlayerControllerListener> listeners = [];

  /// This is just exposed for testing. Do not use it.
  @visibleForTesting
  int get textureId => _textureId;

  ApiVideoPlayerController({
    required this.videoOptions,
    VoidCallback? onReady,
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onEnd,
    Function(Object)? onError,
  }) {
    listeners.add(ApiVideoPlayerControllerListener(
        onReady: onReady,
        onPlay: onPlay,
        onPause: onPause,
        onEnd: onEnd,
        onError: onError));
  }

  ApiVideoPlayerController.fromListener(
      {required this.videoOptions,
      ApiVideoPlayerControllerListener? listener}) {
    if (listener != null) {
      listeners.add(listener);
    }
  }

  Future<bool> get isPlaying async {
    return _playerPlatform.isPlaying(_textureId);
  }

  Future<Duration> get currentTime async {
    final milliseconds = await _playerPlatform.getCurrentTime(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  Future<void> setCurrentTime(Duration currentTime) async {
    return _playerPlatform.setCurrentTime(
        _textureId, currentTime.inMilliseconds);
  }

  Future<Duration> get duration async {
    final milliseconds = await _playerPlatform.getDuration(_textureId);
    return Duration(milliseconds: milliseconds);
  }

  Future<void> initialize() async {
    _textureId = await _playerPlatform.initialize() ?? kUninitializedTextureId;

    _eventSubscription = _playerPlatform
        .playerEventsFor(_textureId)
        .listen(_eventListener, onError: _errorListener);

    await _playerPlatform.create(_textureId, videoOptions);

    return;
  }

  Future<void> play() async {
    return _playerPlatform.play(_textureId);
  }

  Future<void> pause() async {
    return _playerPlatform.pause(_textureId);
  }

  Future<void> dispose() async {
    await _eventSubscription?.cancel();
    listeners.clear();
    await _playerPlatform.dispose(_textureId);
    return;
  }

  Future<void> seek(Duration offset) async {
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
  final VoidCallback? onEnd;
  final Function(Object)? onError;

  ApiVideoPlayerControllerListener(
      {this.onReady, this.onPlay, this.onPause, this.onEnd, this.onError});
}
