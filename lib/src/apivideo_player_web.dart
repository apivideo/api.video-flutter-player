import 'dart:html';
import 'dart:js' as js;

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
  Future<void> dispose(int textureId) {
    // TODO
    throw UnimplementedError('dispose() has not been implemented.');
  }

  @override
  Future<void> play(int textureId) async {
    ArgumentError.checkNotNull(js.context['player$_textureCounter'], 'player');
    js.JsObject.fromBrowserObject(js.context['player$_textureCounter'])
        .callMethod('play');
  }

  @override
  Future<void> pause(int textureId) async {
    ArgumentError.checkNotNull(js.context['player$_textureCounter'], 'player');
    js.JsObject.fromBrowserObject(js.context['player$_textureCounter'])
        .callMethod('pause');
  }

  @override
  Widget buildView(int textureId) {
    if (_videoOptions[textureId] == null) {
      throw ArgumentError('videos options must be provided');
    }

    void injectScript() {
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
        ..id = 'apiVideoPlayerJsScript'
        ..innerText = jsString;
      script.innerHtml = script.innerHtml?.replaceAll('<br>', '');
      document.body?.insertAdjacentElement('beforeend', script);
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: HtmlElementView(
        viewType: 'playerDiv$textureId',
        onPlatformViewCreated: (id) => injectScript(),
      ),
    );
  }
}
