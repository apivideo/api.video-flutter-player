// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:html';

import 'package:apivideo_player/src/javascript_controller.dart'
    as js_controller;
import 'package:apivideo_player/src/platform_view_registry/platform_view_registry.dart';
import 'package:apivideo_player/src/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'apivideo_player_platform_interface.dart';
import 'apivideo_types.dart';
import 'javascript_controller.dart';

/// A web implementation of the ApiVideoPlayerPlatform of the ApiVideoPlayer plugin.
class ApiVideoPlayerPlugin extends ApiVideoPlayerPlatform {
  /// Registers this class as the default instance of [PathProviderPlatform].
  static void registerWith(Registrar registrar) {
    ApiVideoPlayerPlatform.instance = ApiVideoPlayerPlugin();
  }

  int _textureCounter = -1;
  final Map<int, Player> _players = {};

  @override
  Future<bool> isCreated(int textureId) async {
    return _players[textureId]?.isCreated ?? false;
  }

  @override
  Future<int?> initialize(bool autoplay) async {
    final textureCounter = ++_textureCounter;
    _players[textureCounter] = Player(autoplay: autoplay);
    return textureCounter;
  }

  @override
  Future<void> create(int textureId, VideoOptions videoOptions) async {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot create the HTML element.',
      );
    }
    final DivElement videoElement = DivElement()
      ..id = 'playerDiv$textureId'
      ..style.height = '100%'
      ..style.width = '100%';

    platformViewRegistry.registerViewFactory(
        'playerDiv$textureId', (int viewId) => videoElement);

    _players[textureId]!
      ..videoOptions = videoOptions
      ..isCreated = true;
  }

  @override
  Future<void> dispose(int textureId) async {
    _players[textureId]?.playerEvents?.close();
    _players.remove(textureId);
    document.querySelector('#playerDiv$textureId')?.remove();
    document.querySelector('#apiVideoPlayerJsScript$textureId')?.remove();
    return;
  }

  @override
  Future<VideoOptions> getVideoOptions(int textureId) async {
    if (_players[textureId] == null ||
        _players[textureId]?.videoOptions == null) {
      throw Exception(
        'No player or video options found for this texture id: $textureId. Cannot get video options.',
      );
    }
    return _players[textureId]!.videoOptions!;
  }

  @override
  Future<void> setVideoOptions(int textureId, VideoOptions videoOptions) async {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot set video options.',
      );
    }
    _players[textureId]!.videoOptions = videoOptions;
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
  Future<void> setCurrentTime(int textureId, int currentTime) async {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot seek.',
      );
    }
    _players[textureId]!
        .playerEvents!
        .add(PlayerEvent(type: PlayerEventType.seekStarted));
    Utils.callJsMethod(
      textureId: textureId,
      jsMethodName: 'setCurrentTime',
      args: [currentTime ~/ 1000],
    );
  }

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
  Future<void> seek(int textureId, int offset) async {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot seek.',
      );
    }
    _players[textureId]!
        .playerEvents!
        .add(PlayerEvent(type: PlayerEventType.seekStarted));
    return Utils.callJsMethod(
        textureId: textureId, jsMethodName: 'seek', args: [offset ~/ 1000]);
  }

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
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot get autoplay value.',
      );
    }
    return _players[textureId]!.autoplay;
  }

  @override
  Future<void> setAutoplay(int textureId, bool autoplay) {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot set autoplay value',
      );
    }
    _players[textureId]!.autoplay = autoplay;
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
    final jsSize = await Utils.getPromiseFromJs<dynamic>(
      textureId: textureId,
      jsMethod: () => js_controller.getVideoSize('player$textureId'),
    );
    if (jsSize == null) return null;
    final size = jsToMap(jsSize);
    return Size(
      size['width'] as double,
      size['height'] as double,
    );
  }

  @override
  Future<void> setPlaybackSpeed(int textureId, double speedRate) =>
      Utils.callJsMethod(
        textureId: textureId,
        jsMethodName: 'setPlaybackRate',
        args: [speedRate],
      );

  @override
  Future<double> getPlaybackSpeed(int textureId) =>
      Utils.getPromiseFromJs<double>(
        textureId: textureId,
        jsMethod: () => js_controller.getPlaybackRate('player$textureId'),
      );

  @override
  Stream<PlayerEvent> playerEventsFor(int textureId) {
    if (_players[textureId] == null) {
      throw Exception(
        'No player found for this texture id: $textureId. Cannot set player events.',
      );
    }
    final streamController = StreamController<PlayerEvent>();
    streamController.onCancel = () {
      streamController.close();
    };
    _players[textureId]!.playerEvents = streamController;
    return streamController.stream;
  }

  @override
  Widget buildView(int textureId) {
    if (_players[textureId] == null) {
      throw ArgumentError(
        'No player found for this texture id: $textureId. Cannot build view.',
      );
    }
    if (_players[textureId]!.videoOptions == null) {
      throw ArgumentError(
        'No video options found for this texture id: $textureId. Cannot build view.',
      );
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
            setPlaybackRate: async function(playerId, playbackRate) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].setPlaybackRate(playbackRate);
            },
            getPlaybackRate: async function(playerId) {
              if (!playerId || !window[playerId]) return;
              return await window[playerId].getPlaybackRate();
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
            id: "${_players[textureId]!.videoOptions!.videoId}",
            chromeless: true,
            live: ${_players[textureId]!.videoOptions!.videoType == VideoType.live},
            autoplay: ${_players[textureId]!.autoplay},
          }
        );
      ''';
      final ScriptElement script = ScriptElement()
        ..id = 'apiVideoPlayerJsScript$textureId'
        ..innerText = jsString;
      script.innerHtml = script.innerHtml?.replaceAll('<br>', '');
      document.body?.insertAdjacentElement('beforeend', script);

      if (_players[textureId]!.playerEvents == null) {
        throw Exception('No player events for this texture id: $textureId.');
      }
      for (var playerEvent in PlayerEventType.values) {
        Utils.callJsMethod(
          textureId: textureId,
          jsMethodName: 'addEventListener',
          args: [
            playerEvent.displayPlayerSdkName,
            (userData) => _players[textureId]!
                .playerEvents!
                .add(PlayerEvent(type: playerEvent)),
          ],
        );
      }

      // Hide iframe border
      if (document.head !=  null) {
        StyleElement styleElement = StyleElement();
        document.head!.append(styleElement);
        CssStyleSheet sheet = styleElement.sheet as CssStyleSheet;
        const rule = 'iframe { border: none; }';
        sheet.insertRule(rule, 0);
      }
    }

    return HtmlElementView(
      viewType: 'playerDiv$textureId',
      onPlatformViewCreated: (id) => injectScripts(),
    );
  }
}

class Player {
  Player({
    this.autoplay = false,
    this.isCreated = false,
    this.videoOptions,
    this.playerEvents,
  });

  bool autoplay;
  bool isCreated;
  VideoOptions? videoOptions;
  StreamController<PlayerEvent>? playerEvents;
}
