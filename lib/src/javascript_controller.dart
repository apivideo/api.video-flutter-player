@JS('window')
library script.js;

import 'package:js/js.dart';

@JS('state.getCurrentTime')
external int getCurrentTimeFromJs(String playerId);
@JS('state.setCurrentTime')
external void setCurrentTimeFromJs(String playerId, int currentTimeInSeconds);
@JS('state.getDuration')
external int getDurationFromJs(String playerId);