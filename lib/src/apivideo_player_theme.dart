import 'package:apivideo_player/src/apivideo_player_overlay.dart';
import 'package:flutter/material.dart';

/// A customizable theme for the player.
///
/// ```dart
/// final PlayerTheme theme = const PlayerTheme(
///   controlsColor: Colors.yellow,
///   activeTimeSliderColor: Colors.blue,
///   inactiveTimeSliderColor: Colors.red,
/// );
/// ```
class PlayerTheme {
  const PlayerTheme({
    this.controlsColor = Colors.white,
    this.activeTimeSliderColor = ApiVideoColors.orange,
    this.inactiveTimeSliderColor = Colors.grey,
    this.activeVolumeSliderColor = Colors.white,
    this.inactiveVolumeSliderColor = Colors.grey,
  });

  final Color controlsColor;
  final Color activeTimeSliderColor;
  final Color inactiveTimeSliderColor;
  final Color activeVolumeSliderColor;
  final Color inactiveVolumeSliderColor;
}
