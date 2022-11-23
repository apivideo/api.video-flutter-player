import 'dart:js' as js;
import 'dart:js_util';

import 'package:apivideo_player/src/apivideo_player_platform_interface.dart';

class Utils {
  /// Calls a JS object method that returns void only.
  static Future<void> callJsMethod({
    required int textureId,
    required String jsMethodName,
    List<dynamic>? args,
  }) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    js.JsObject.fromBrowserObject(js.context['player$textureId']).callMethod(
      jsMethodName,
      args,
    );
    return;
  }

  /// Handle a JS [Promise] that returns a value other than void
  /// and parse it into a Dart [Future].
  static Future<T> getPromiseFromJs<T>({
    required int textureId,
    required Function jsMethod,
  }) async {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    ArgumentError.checkNotNull(js.context['state'], 'state');
    return await promiseToFuture(
      jsMethod(),
    );
  }

  /// Converts seconds into milliseconds.
  static int secondsToMilliseconds({required double seconds}) =>
      int.parse((seconds * 1000).toStringAsFixed(0));
}

extension SelectedPlayerEventType on PlayerEventType {
  /// Cast the [PlayerEventType] name to his corresponding TypeScript PlayerSdk
  /// event
  String get displayPlayerSdkName {
    switch (this) {
      case PlayerEventType.ready:
        return 'ready';
      case PlayerEventType.played:
        return 'play';
      case PlayerEventType.paused:
        return 'pause';
      case PlayerEventType.seek:
        return 'seeking';
      case PlayerEventType.ended:
        return 'ended';
      default:
        return 'unknown';
    }
  }
}

extension ConvertMapToJsObject on Map {
  /// Parse a [Map] to a Javascript object.
  Object toJsObject() {
    var object = newObject();
    forEach((k, v) {
      if (v is Map) {
        setProperty(object, k, toJsObject());
      } else {
        setProperty(object, k, v);
      }
    });
    return object;
  }
}
