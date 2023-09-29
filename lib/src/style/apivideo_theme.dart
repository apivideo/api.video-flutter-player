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
  });

  /// The color of the icons.
  final Color iconsColor;

  /// The color to use for the portion of the time slider track that is active.
  ///
  /// The "active" side of the time slider is the side between the thumb
  /// (current time) and the minimum value.
  final Color timeSliderActiveColor;

  /// The color for the inactive portion of the time slider track.
  ///
  /// The "inactive" side of the time slider is the side between the thumb
  /// (current time) and the maximum value.
  ///
  final Color timeSliderInactiveColor;

  /// The color given to the thumb to draw itself with.
  final Color timeSliderThumbColor;

  /// The color of the time slider text (current position).
  final Color timeSliderTextColor;

  /// The color to use for the portion of the volume slider track that is active.
  ///
  /// The "active" side of the volume slider is the side between the thumb
  /// and the minimum value.
  ///
  /// Volume slider is only visible on web.
  final Color volumeSliderActiveColor;

  /// The color for the inactive portion of the volume slider track.
  ///
  /// The "inactive" side of the time slider is the side between the thumb
  /// and the maximum value.
  ///
  /// Volume slider is only visible on web.
  final Color volumeSliderInactiveColor;

  /// The color given to the thumb to draw itself with.
  ///
  /// Volume slider is only visible on web.
  final Color volumeSliderThumbColor;

  /// The default theme.
  static const ApiVideoPlayerTheme defaultTheme = ApiVideoPlayerTheme();
}
