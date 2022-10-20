// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;
import 'dart:html';
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/shims/dart_ui.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'apivideo_player_platform_interface.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;

/// A web implementation of the ApiVideoPlayerPlatform of the ApiVideoPlayer plugin.
// class ApiVideoPlayerWeb extends ApiVideoPlayerPlatform {
//   /// Constructs a ApiVideoPlayerWeb
//   ApiVideoPlayerWeb();

//   static void registerWith(Registrar registrar) {
//     ApiVideoPlayerPlatform.instance = ApiVideoPlayerWeb();
//   }

//   /// Returns a [String] containing the version of the platform.
//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = html.window.navigator.userAgent;
//     return version;
//   }
// }

class ApiVideoPlayerWeb extends StatefulWidget {
  // Constructs a ApiVideoPlayerWeb
  const ApiVideoPlayerWeb({super.key});

  static void registerWith(Registrar registrar) {
    // ScriptElement script = ScriptElement()
    //   ..innerText = '''
    //       window.player = new PlayerSdk("#playerDiv", { id: "vi2z94GxBgbkBrTkspLuXuBZ" });
    //     ''';
    // document.body?.insertAdjacentElement('beforeend', script);
    createScript();
  }

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
