import 'dart:html';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'apivideo_player_platform_interface.dart';
import 'apivideo_types.dart';

/// A web implementation of the ApiVideoPlayerPlatform of the ApiVideoPlayer plugin.
 class ApiVideoPlayerPlugin extends ApiVideoPlayerPlatform {
   /// Registers this class as the default instance of [PathProviderPlatform].
   static void registerWith(Registrar registrar) {
     ApiVideoPlayerPlatform.instance = ApiVideoPlayerPlugin();
   }

   @override
   Future<int?> create(VideoOptions videoOptions) {
     // TODO
     throw UnimplementedError('create() has not been implemented.');
   }

   @override
   Future<void> dispose(int textureId) {
     // TODO
     throw UnimplementedError('dispose() has not been implemented.');
   }

   @override
   Future<void> play(int textureId) {
     // TODO
     throw UnimplementedError('play() has not been implemented.');
   }

   @override
   Future<void> pause(int textureId) {
     // TODO
     throw UnimplementedError('pause() has not been implemented.');
   }

   @override
   Widget buildView(int textureId) {
     // TODO
     throw UnimplementedError('buildView() has not been implemented.');
   }
}

class ApiVideoPlayerWeb extends StatefulWidget {
  // Constructs a ApiVideoPlayerWeb
  const ApiVideoPlayerWeb({super.key});

 // static void registerWith(Registrar registrar) {
    // ScriptElement script = ScriptElement()
    //   ..innerText = '''
    //       window.player = new PlayerSdk("#playerDiv", { id: "vi2z94GxBgbkBrTkspLuXuBZ" });
    //     ''';
    // document.body?.insertAdjacentElement('beforeend', script);
  //  createScript();
 // }

  static void createScript() {
    ScriptElement script = ScriptElement()
      ..innerText = '''
          window.state = { name: 'api.video' };
          // window.player = new PlayerSdk("#playerDiv", { id: "vi2z94GxBgbkBrTkspLuXuBZ" });
        ''';
    document.body?.insertAdjacentElement('beforeend', script);
    var elem = querySelector('#playerDiv');
    print(elem);
  }

  @override
  State<ApiVideoPlayerWeb> createState() => _ApiVideoPlayerWebState();
}

class _ApiVideoPlayerWebState extends State<ApiVideoPlayerWeb> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ApiVideoPlayerWeb.createScript());
  }

  @override
  Widget build(BuildContext context) {
    var state = js.JsObject.fromBrowserObject(js.context['state']);
    print(state['name']);

    // WidgetsBinding.instance.addPostFrameCallback((_) => ApiVideoPlayerWeb.createScript);
    String htmlData = '''
      <div id="playerDiv">DIV</div>
    ''';
    return Html(data: htmlData);
  }
}
