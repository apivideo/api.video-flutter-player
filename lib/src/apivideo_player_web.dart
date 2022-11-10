import 'dart:async';
import 'dart:html';

import 'package:apivideo_player/src/javascript_controller.dart'
    as js_controller;
import 'package:apivideo_player/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'apivideo_player_platform_interface.dart';
import 'apivideo_types.dart';

/// A web implementation of the ApiVideoPlayerPlatform of the ApiVideoPlayer plugin.
class ApiVideoPlayerPlugin extends ApiVideoPlayerPlatform {
  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith(Registrar registrar) {
    ApiVideoPlayerPlatform.instance = ApiVideoPlayerPlugin();
  }

  int _textureCounter = -1;
  final Map<int, bool> _isCreated = {};
  final Map<int, bool> _autoplay = {};
  final Map<int, VideoOptions> _videoOptions = {};
  final Map<int, StreamController<PlayerEvent>> _streamControllers = {};

  @override
  Future<bool> isCreated(int textureId) async {
    return _isCreated[textureId] ?? false;
  }

  @override
  Future<int?> initialize(bool autoplay) async {
    final textureCounter = ++_textureCounter;
    _isCreated[textureCounter] = false;
    _autoplay[textureCounter] = autoplay;
    return textureCounter;
  }

  @override
  Future<void> create(int textureId, VideoOptions videoOptions) async {
    final DivElement videoElement = DivElement()
      ..id = 'playerDiv$textureId'
      ..style.height = '100%'
      ..style.width = '100%';

    platformViewRegistry.registerViewFactory(
        'playerDiv$textureId', (int viewId) => videoElement);

    _videoOptions[textureId] = videoOptions;
  }

  @override
  Future<void> dispose(int textureId) async {
    _isCreated.remove(textureId);
    _videoOptions.remove(textureId);
    _streamControllers.remove(textureId);
    document.querySelector('#playerDiv$textureId')?.remove();
    document.querySelector('#apiVideoPlayerJsScript$textureId')?.remove();
    return;
  }

  @override
  Future<VideoOptions> getVideoOptions(int textureId) async {
    if (_videoOptions[textureId] == null) {
      throw Exception('No video options found for this texture id: $textureId');
    }
    return _videoOptions[textureId]!;
  }

  @override
  Future<void> setVideoOptions(int textureId, VideoOptions videoOptions) async {
    _videoOptions[textureId] = videoOptions;
    js_controller.loadConfig(
      'player$textureId',
      {
        'id': videoOptions.videoId,
        'live': videoOptions.videoType == VideoType.live,
      }.toJsObject(),
    );
    return;
  }

  @override
  Future<bool> isPlaying(int textureId) async =>
      await Utils.getPromiseFromJs<bool>(
        textureId: textureId,
        jsMethod: () => js_controller.getPlayingFromJs('player$textureId'),
      );

  @override
  Future<int> getCurrentTime(int textureId) async {
    final currentTime = await Utils.getPromiseFromJs<double>(
      textureId: textureId,
      jsMethod: () => js_controller.getCurrentTimeFromJs('player$textureId'),
    );
    return Utils.secondsToMilliseconds(seconds: currentTime);
  }

  @override
  Future<void> setCurrentTime(int textureId, int currentTime) async =>
      Utils.callJsMethod(
        textureId: textureId,
        jsMethodName: 'setCurrentTime',
        args: [currentTime ~/ 1000],
      );

  @override
  Future<int> getDuration(int textureId) async {
    final duration = await Utils.getPromiseFromJs<double>(
      textureId: textureId,
      jsMethod: () => js_controller.getDurationFromJs('player$textureId'),
    );
    return Utils.secondsToMilliseconds(seconds: duration);
  }

  @override
  Future<void> play(int textureId) async =>
      Utils.callJsMethod(textureId: textureId, jsMethodName: 'play');

  @override
  Future<void> pause(int textureId) async =>
      Utils.callJsMethod(textureId: textureId, jsMethodName: 'pause');

  @override
  Future<void> seek(int textureId, int offset) async => Utils.callJsMethod(
      textureId: textureId, jsMethodName: 'seek', args: [offset ~/ 1000]);

  @override
  Future<double> getVolume(int textureId) => Utils.getPromiseFromJs<double>(
        textureId: textureId,
        jsMethod: () => js_controller.getVolume('player$textureId'),
      );

  @override
  Future<void> setVolume(int textureId, double volume) => Utils.callJsMethod(
        textureId: textureId,
        jsMethodName: 'setVolume',
        args: [volume],
      );

  @override
  Future<bool> getIsMuted(int textureId) => Utils.getPromiseFromJs<bool>(
        textureId: textureId,
        jsMethod: () => js_controller.getMuted('player$textureId'),
      );

  @override
  Future<void> setIsMuted(int textureId, bool isMuted) => Utils.callJsMethod(
        textureId: textureId,
        jsMethodName: isMuted ? 'mute' : 'unmute',
      );

  @override
  Future<bool> getAutoplay(int textureId) async {
    if (_autoplay[textureId] == null) {
      throw Exception(
        'No autoplay property value found for this texture id: $textureId',
      );
    }
    return _autoplay[textureId]!;
  }

  @override
  Future<void> setAutoplay(int textureId, bool autoplay) {
    _autoplay[textureId] = autoplay;
    return Utils.callJsMethod(
      textureId: textureId,
      jsMethodName: 'setAutoplay',
      args: [autoplay],
    );
  }

  @override
  Future<bool> getIsLooping(int textureId) => Utils.getPromiseFromJs<bool>(
        textureId: textureId,
        jsMethod: () => js_controller.getLoop('player$textureId'),
      );

  @override
  Future<void> setIsLooping(int textureId, bool isLooping) =>
      Utils.callJsMethod(
        textureId: textureId,
        jsMethodName: 'setLoop',
        args: [isLooping],
      );

  @override
  Future<Size?> getVideoSize(int textureId) async {
    final size = await Utils.getPromiseFromJs<dynamic>(
      textureId: textureId,
      jsMethod: () => js_controller.getVideoSize('player$textureId'),
    );

    return Size(size.width, size.height);
  }

  @override
  Stream<PlayerEvent> playerEventsFor(int textureId) {
    final streamController = StreamController<PlayerEvent>();
    _streamControllers[textureId] = streamController;
    return streamController.stream;
  }

  @override
  Widget buildView(int textureId) {
    if (_videoOptions[textureId] == null) {
      throw ArgumentError('videos options must be provided');
    }

    void injectScripts() {
      if (document.body?.querySelector('#playersState') == null) {
        const String jsString = '''
          window.state = {
            getCurrentTime: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getCurrentTime();
            },
            setCurrentTime: async function(playerId, currentTime) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].setCurrentTime(currentTime);
            },
            getDuration: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getDuration();
            },
            getPlaying: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getPlaying();
            },
            getMuted: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getMuted();
            },
            getLoop: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getLoop();
            },
            getVolume: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getVolume();
            },
            getVideoSize: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getVideoSize();
            },
            loadConfig: function(playerId, videoOptions) {
              if (!playerId || !window[playerId]) return;
              console.log(videoOptions);
              window[playerId].loadConfig(videoOptions);
            }
          };
        ''';
        final ScriptElement script = ScriptElement()
          ..id = 'playersState'
          ..innerText = jsString;
        script.innerHtml = script.innerHtml?.replaceAll('<br>', '');
        document.body?.insertAdjacentElement('beforeend', script);
      }

      final String jsString = '''
        window.player$textureId = new PlayerSdk(
          "#playerDiv$textureId",
          { 
            id: "${_videoOptions[textureId]!.videoId}",
            chromeless: true,
            live: ${_videoOptions[textureId]!.videoType == VideoType.live},
            autoplay: $_autoplay,
          }
        );
      ''';
      final ScriptElement script = ScriptElement()
        ..id = 'apiVideoPlayerJsScript$textureId'
        ..innerText = jsString;
      script.innerHtml = script.innerHtml?.replaceAll('<br>', '');
      document.body?.insertAdjacentElement('beforeend', script);

      if (_streamControllers[textureId] == null) {
        throw Exception('No stream controller for this texture id: $textureId');
      }
      for (var playerEvent in PlayerEventType.values) {
        Utils.callJsMethod(
          textureId: textureId,
          jsMethodName: 'addEventListener',
          args: [
            playerEvent.displayPlayerSdkName,
            () => _streamControllers[textureId]!
                .add(PlayerEvent(type: playerEvent)),
          ],
        );
      }

      _isCreated[textureId] = true;
    }

    return HtmlElementView(
      viewType: 'playerDiv$textureId',
      onPlatformViewCreated: (id) => injectScripts(),
    );
  }
}
