import 'package:flutter/material.dart';

import 'apivideo_colors.dart';

/// A customizable theme for the player.
///
/// ```dart
/// final PlayerTheme theme = const PlayerTheme(
///   iconsColor: Colors.yellow,
///   activeTimeSliderColor: Colors.blue,
///   inactiveTimeSliderColor: Colors.red,
/// );
/// ```
class ApiVideoPlayerTheme {
  const ApiVideoPlayerTheme({
    this.iconsColor = Colors.white,
    this.timeSliderActiveColor = ApiVideoColors.orange,
    this.timeSliderInactiveColor = Colors.grey,
    this.timeSliderThumbColor = ApiVideoColors.orange,
    this.timeSliderTextColor = Colors.white,
    this.volumeSliderActiveColor = Colors.white,
    this.volumeSliderInactiveColor = Colors.grey,
    this.volumeSliderThumbColor = Colors.white,
    this.selectedColor = ApiVideoColors.orange,
    this.boxDecorationColor = Colors.grey,
  });

  final Color iconsColor;
  final Color timeSliderActiveColor;
  final Color timeSliderInactiveColor;
  final Color timeSliderThumbColor;
  final Color timeSliderTextColor;
  final Color volumeSliderActiveColor;
  final Color volumeSliderInactiveColor;
  final Color volumeSliderThumbColor;
  final Color selectedColor;
  final Color boxDecorationColor;

  static const ApiVideoPlayerTheme defaultTheme = ApiVideoPlayerTheme();
}
