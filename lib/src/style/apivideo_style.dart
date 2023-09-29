import 'package:apivideo_player/src/style/apivideo_colors.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_controls_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_settings_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_time_slider.dart';
import 'package:flutter/material.dart';

/// Customizable style for the player.
class ApiVideoPlayerStyle {
  const ApiVideoPlayerStyle({
    this.settingsBarStyle,
    this.controlBarStyle,
    this.timeSliderStyle,
  });

  /// The style of the settings button (volume, playback rate,...).
  final ApiVideoPlayerSettingsBarStyle? settingsBarStyle;

  /// The style of the control buttons (play, pause, rewind, seek forward and backward).
  final ApiVideoPlayerControlsBarStyle? controlBarStyle;

  /// The style of the time slider.
  final ApiVideoPlayerTimeSliderStyle? timeSliderStyle;

  /// api.video default style.
  static ApiVideoPlayerStyle styleFromApiVideo() {
    const textStyle = TextStyle(color: Colors.white);
    final buttonStyle = TextButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        side: BorderSide.none,
        textStyle: textStyle);

    final settingsBarStyle = ApiVideoPlayerSettingsBarStyle(
        buttonStyle: buttonStyle,
        sliderTheme: SliderThemeData(
            activeTrackColor: Colors.white,
            thumbColor: Colors.white,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6.0,
            )));

    final controlBarStyle = ApiVideoPlayerControlsBarStyle.styleFrom(
        mainControlButtonStyle: buttonStyle);

    final timeSliderStyle = ApiVideoPlayerTimeSliderStyle(
        sliderTheme: const SliderThemeData(
            activeTrackColor: ApiVideoColors.orange,
            inactiveTrackColor: Colors.grey,
            thumbColor: ApiVideoColors.orange,
            valueIndicatorTextStyle: textStyle));

    return ApiVideoPlayerStyle(
        settingsBarStyle: settingsBarStyle,
        controlBarStyle: controlBarStyle,
        timeSliderStyle: timeSliderStyle);
  }

  ApiVideoPlayerStyle copyWith({
    ApiVideoPlayerSettingsBarStyle? settingsBarStyle,
    ApiVideoPlayerControlsBarStyle? controlBarStyle,
    ApiVideoPlayerTimeSliderStyle? timeSliderStyle,
  }) =>
      ApiVideoPlayerStyle(
          settingsBarStyle: settingsBarStyle ?? this.settingsBarStyle,
          controlBarStyle: controlBarStyle ?? this.controlBarStyle,
          timeSliderStyle: timeSliderStyle ?? this.timeSliderStyle);

  /// Extracts the style of the player from the [context].
  ///
  /// The following themes are retrieved from application theme:
  /// - [ThemeData.iconButtonTheme] for the settings button (volume,...).
  /// - [ThemeData.iconButtonTheme] for the main control buttons (play, pause, rewind).
  /// - [ThemeData.iconButtonTheme] for the side control buttons (seek forward and backward).
  /// - [ThemeData.sliderTheme] for the time slider.
  /// - [ThemeData.sliderTheme] for the other sliders (except the time slider).
  static ApiVideoPlayerStyle of(BuildContext context) => ApiVideoPlayerStyle(
      settingsBarStyle: ApiVideoPlayerSettingsBarStyle.of(context),
      controlBarStyle: ApiVideoPlayerControlsBarStyle.of(context),
      timeSliderStyle: ApiVideoPlayerTimeSliderStyle.of(context));

  /// The default theme of the player.
  static ApiVideoPlayerStyle defaultStyle = styleFromApiVideo();
}
