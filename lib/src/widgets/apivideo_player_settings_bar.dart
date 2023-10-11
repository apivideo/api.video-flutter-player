import 'package:apivideo_player/src/widgets/common/apivideo_player_multi_text_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apivideo_player_volume_slider.dart';

class SettingsBarController {
  final volumeController = VolumeSliderController();

  double get volume => volumeController.volume;

  set volume(double newVolume) {
    volumeController.volume = newVolume;
  }

  bool get isMuted => volumeController.isMuted;

  set isMuted(bool newIsMuted) {
    volumeController.isMuted = newIsMuted;
  }

  void dispose() {
    volumeController.dispose();
  }
}

class SettingsBar extends StatefulWidget {
  const SettingsBar(
      {super.key,
      required this.controller,
      this.onToggleMute,
      this.onVolumeChanged,
      this.onSpeedRateChanged,
      this.style});

  final SettingsBarController controller;

  final VoidCallback? onToggleMute;
  final ValueChanged<double>? onVolumeChanged;

  final ValueChanged<double>? onSpeedRateChanged;

  final SettingsBarStyle? style;

  @override
  State<SettingsBar> createState() => _SettingsBarState();
}

class _SettingsBarState extends State<SettingsBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kIsWeb
              ? VolumeSlider(
                  controller: widget.controller.volumeController,
                  onVolumeChanged: (volume) {
                    if (widget.onVolumeChanged != null) {
                      widget.onVolumeChanged!(volume);
                    }
                  },
                  onToggleMute: () {
                    if (widget.onToggleMute != null) {
                      widget.onToggleMute!();
                    }
                  },
                  style: VolumeSliderStyle(
                    buttonStyle: widget.style?.buttonStyle,
                    sliderTheme: widget.style?.sliderTheme,
                  ))
              : Container(),
          MultiTextButton(
            keysValues: const {
              '0.5x': 0.5,
              '1.0x': 1.0,
              '1.2x': 1.2,
              '1.5x': 1.5,
              '2.0x': 2.0,
            },
            defaultKey: "1.0x",
            onValueChanged: (speed) {
              if (widget.onSpeedRateChanged != null) {
                widget.onSpeedRateChanged!(speed);
              }
            },
            size: 17,
            style: widget.style?.buttonStyle,
          )
        ]);
  }
}

class SettingsBarStyle {
  const SettingsBarStyle.raw({this.buttonStyle, required this.sliderTheme});

  final ButtonStyle? buttonStyle;
  final SliderThemeData sliderTheme;

  factory SettingsBarStyle({
    ButtonStyle? buttonStyle,
    SliderThemeData? sliderTheme,
  }) {
    sliderTheme ??= const SliderThemeData();

    return SettingsBarStyle.raw(
        buttonStyle: buttonStyle, sliderTheme: sliderTheme);
  }

  SettingsBarStyle copyWith({
    ButtonStyle? buttonStyle,
    SliderThemeData? sliderTheme,
  }) {
    return SettingsBarStyle.raw(
        buttonStyle: buttonStyle ?? this.buttonStyle,
        sliderTheme: sliderTheme ?? this.sliderTheme);
  }

  /// Applies the [Theme.iconButtonTheme] to all buttons and the
  /// [Theme.sliderTheme] to the slider.
  static SettingsBarStyle of(BuildContext context) {
    final iconButtonTheme = Theme.of(context).iconButtonTheme;
    final sliderTheme = Theme.of(context).sliderTheme;

    return SettingsBarStyle(
        buttonStyle: iconButtonTheme.style, sliderTheme: sliderTheme);
  }
}
