@JS('window')
library script.js;

import 'package:js/js_util.dart' as js;

import 'package:js/js.dart';

@JS('state.getCurrentTime')
external int getCurrentTime(String playerId);

@JS('state.setCurrentTime')
external void setCurrentTime(String playerId, int currentTimeInSeconds);

@JS('state.getDuration')
external double getDuration(String playerId);

@JS('state.getPlaying')
external bool getPlaying(String playerId);

@JS('state.isLiveStream')
external bool isLiveStream(String playerId);

@JS('state.getMuted')
external bool getMuted(String playerId);

@JS('state.getLoop')
external bool getLoop(String playerId);

@JS('state.getVolume')
external double getVolume(String playerId);

@JS('state.getVideoSize')
external dynamic getVideoSize(String playerId);

@JS('state.getPlaybackRate')
external double getPlaybackRate(String playerId);

@JS('state.loadConfig')
external void loadConfig(String playerId, Object videoOptions);

dynamic _nested(dynamic val) {
  if (val.runtimeType.toString() == 'LegacyJavaScriptObject') {
    return jsToMap(val);
  }
  return val;
}

/// A workaround to converting an object from JS to a Dart Map.
Map jsToMap(jsObject) {
  return Map.fromIterable(_getKeysOfObject(jsObject), value: (key) {
    return _nested(js.getProperty(jsObject, key));
  });
}

// Both of these interfaces exist to call `Object.keys` from Dart.
//
// But you don't use them directly. Just see `jsToMap`.
@JS('Object.keys')
external List<String> _getKeysOfObject(jsObject);
