import 'dart:js' as js;
import 'dart:js_util';

class Utils {
  /// Calls a JS object method that returns void only.
  static dynamic callJsMethod({
    required int textureId,
    required String jsMethodName,
    List<dynamic>? args,
  }) {
    ArgumentError.checkNotNull(js.context['player$textureId'], 'player');
    return js.JsObject.fromBrowserObject(js.context['player$textureId'])
        .callMethod(
      jsMethodName,
      args,
    );
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
