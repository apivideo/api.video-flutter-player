@JS('window')
library script.js;

import 'package:js/js.dart';

@JS('state.getCurrentTime')
external int getCurrentTimeFromJs(String playerId);
@JS('state.setCurrentTime')
external int setCurrentTimeFromJs(String playerId, int currentTimeInSeconds);
