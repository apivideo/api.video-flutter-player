import 'dart:html';
import 'dart:js' as js;
import 'dart:js_util';

import 'package:apivideo_player/src/javascript_controller.dart'
    as js_controller;
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
  final Map<int, VideoOptions> _videoOptions = {};

  @override
  Future<int?> create(VideoOptions videoOptions) async {
    _textureCounter++;

    final DivElement videoElement = DivElement()
      ..id = 'playerDiv$_textureCounter'
      ..style.height = '100%'
      ..style.width = '100%';

    platformViewRegistry.registerViewFactory(
        'playerDiv$_textureCounter', (int viewId) => videoElement);

    _videoOptions[_textureCounter] = videoOptions;
    return _textureCounter;
  }

  @override
  Future<void> dispose(int textureId) async {
    _videoOptions.remove(textureId);
    document.querySelector('#playerDiv$textureId')?.remove();
    document.querySelector('#apiVideoPlayerJsScript$textureId')?.remove();
    return;
  }

  @override
  Future<bool> isPlaying(int textureId) async {
    // TODO: implement isPlaying
    return false;
  }

  @override
  Future<int> getCurrentTime(int textureId) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    ArgumentError.checkNotNull(js.context['state'], 'state');
    final currentTime = await promiseToFuture(
      js_controller.getCurrentTimeFromJs('player$textureId'),
    );
    return int.parse((currentTime * 1000).toStringAsFixed(0));
  }

  @override
  Future<void> setCurrentTime(int textureId, int currentTime) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    js_controller.setCurrentTimeFromJs(
      'player$textureId',
      (currentTime ~/ 1000).toInt(),
    );
  }

  @override
  Future<void> play(int textureId) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    js.JsObject.fromBrowserObject(js.context['player$textureId'])
        .callMethod('play');
  }

  @override
  Future<void> pause(int textureId) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    js.JsObject.fromBrowserObject(js.context['player$textureId'])
        .callMethod('pause');
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
              if (!playerId) return;
              return await window[playerId].getCurrentTime();
            },
            setCurrentTime: async function(playerId, currentTime) {
              if (!playerId) return;
              return await window[playerId].setCurrentTime(currentTime);
            },
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
          }
        );
      ''';
      final ScriptElement script = ScriptElement()
        ..id = 'apiVideoPlayerJsScript$textureId'
        ..innerText = jsString;
      script.innerHtml = script.innerHtml?.replaceAll('<br>', '');
      document.body?.insertAdjacentElement('beforeend', script);
    }

    return HtmlElementView(
      viewType: 'playerDiv$textureId',
      onPlatformViewCreated: (id) => injectScripts(),
    );
  }
}
