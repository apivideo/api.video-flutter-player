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

  @override
  Future<int?> create(VideoOptions videoOptions) async {
    final DivElement videoElement = DivElement()
      ..id = 'playerDiv'
      ..style.height = '100%'
      ..style.width = '100%';

    final int textureCounter = _textureCounter++;

    platformViewRegistry.registerViewFactory(
        'playerDiv$textureCounter', (int viewId) => videoElement);

    return textureCounter;
  }

  @override
  Future<void> dispose(int textureId) {
    // TODO
    throw UnimplementedError('dispose() has not been implemented.');
  }

  @override
  Future<void> play(int textureId) async {
    ArgumentError.checkNotNull(js.context['player'], 'player');
    js.JsObject.fromBrowserObject(js.context['player']).callMethod('play');
  }

  @override
  Future<void> pause(int textureId) async {
    ArgumentError.checkNotNull(js.context['player'], 'player');
    js.JsObject.fromBrowserObject(js.context['player']).callMethod('pause');
  }

  @override
  Widget buildView(int textureId) {
    void injectScript() {
      ScriptElement script = ScriptElement()
        ..innerText = '''
            window.state = { name: 'api.video' };
            window.player = new PlayerSdk("#playerDiv", { id: "vi7jYu4ydRwgvwhwEeuD1sWj" });
          ''';
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
