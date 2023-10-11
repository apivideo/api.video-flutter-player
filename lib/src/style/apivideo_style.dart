import 'package:apivideo_player/src/style/apivideo_colors.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_controls_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_settings_bar.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_time_slider.dart';
import 'package:flutter/material.dart';

/// Customizable style for the player.
class PlayerStyle {
  const PlayerStyle({
    this.settingsBarStyle,
    this.controlsBarStyle,
    this.timeSliderStyle,
  });

  /// The style of the settings button (volume, playback rate,...).
  final SettingsBarStyle? settingsBarStyle;

  /// The style of the control buttons (play, pause, rewind, seek forward and backward).
  final ControlsBarStyle? controlsBarStyle;

  /// The style of the time slider.
  final TimeSliderStyle? timeSliderStyle;

  /// api.video default style.
  static PlayerStyle styleFromApiVideo() {
    const textStyle = TextStyle(color: Colors.white);
    final buttonStyle = TextButton.styleFrom(
        iconColor: Colors.white,
        foregroundColor: Colors.white,
        side: BorderSide.none,
        textStyle: textStyle);

    final settingsBarStyle = SettingsBarStyle(
        buttonStyle: buttonStyle,
        sliderTheme: SliderThemeData(
            activeTrackColor: Colors.white,
            thumbColor: Colors.white,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6.0,
            )));

    final controlsBarStyle =
        ControlsBarStyle.styleFrom(mainControlButtonStyle: buttonStyle);

    final timeSliderStyle = TimeSliderStyle(
        sliderTheme: const SliderThemeData(
            activeTrackColor: ApiVideoColors.orange,
            inactiveTrackColor: Colors.grey,
            thumbColor: ApiVideoColors.orange,
            valueIndicatorTextStyle: textStyle));

    return PlayerStyle(
        settingsBarStyle: settingsBarStyle,
        controlsBarStyle: controlsBarStyle,
        timeSliderStyle: timeSliderStyle);
  }

  PlayerStyle copyWith({
    SettingsBarStyle? settingsBarStyle,
    ControlsBarStyle? controlsBarStyle,
    TimeSliderStyle? timeSliderStyle,
  }) =>
      PlayerStyle(
          settingsBarStyle: settingsBarStyle ?? this.settingsBarStyle,
          controlsBarStyle: controlsBarStyle ?? this.controlsBarStyle,
          timeSliderStyle: timeSliderStyle ?? this.timeSliderStyle);

  /// Extracts the style of the player from the [context].
  ///
  /// The following themes are retrieved from application theme:
  /// - [ThemeData.iconButtonTheme] for the settings button (volume,...).
  /// - [ThemeData.iconButtonTheme] for the main control buttons (play, pause, rewind).
  /// - [ThemeData.iconButtonTheme] for the side control buttons (seek forward and backward).
  /// - [ThemeData.sliderTheme] for the time slider.
  /// - [ThemeData.sliderTheme] for the other sliders (except the time slider).
  static PlayerStyle of(BuildContext context) => PlayerStyle(
      settingsBarStyle: SettingsBarStyle.of(context),
      controlsBarStyle: ControlsBarStyle.of(context),
      timeSliderStyle: TimeSliderStyle.of(context));

  /// The default theme of the player.
  static PlayerStyle defaultStyle = styleFromApiVideo();
}
