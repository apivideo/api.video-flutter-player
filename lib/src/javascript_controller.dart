@JS('window')
library script.js;

import 'package:js/js.dart';

@JS('state.getCurrentTime')
external int getCurrentTimeFromJs(String playerId);
@JS('state.setCurrentTime')
external void setCurrentTimeFromJs(String playerId, int currentTimeInSeconds);
@JS('state.getDuration')
external double getDurationFromJs(String playerId);
@JS('state.getPlaying')
external bool getPlayingFromJs(String playerId);
@JS('state.getMuted')
external bool getMuted(String playerId);
@JS('state.getLoop')
external bool getLoop(String playerId);
