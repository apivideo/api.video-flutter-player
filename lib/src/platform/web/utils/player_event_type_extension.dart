import 'package:apivideo_player/src/platform/apivideo_player_platform_interface.dart';

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
