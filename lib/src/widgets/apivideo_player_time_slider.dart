import 'dart:math';

import 'package:apivideo_player/src/utils/extensions/duration_extension.dart';
import 'package:flutter/material.dart';

class TimeSliderValue {
  final Duration currentTime;
  final Duration duration;

  const TimeSliderValue({
    this.currentTime = Duration.zero,
    this.duration = Duration.zero,
  });

  /// Creates a copy of this value but with the given fields replaced with the new values.
  TimeSliderValue copyWith({Duration? currentTime, Duration? duration}) {
    return TimeSliderValue(
        currentTime: currentTime ?? this.currentTime,
        duration: duration ?? this.duration);
  }
}

class ApiVideoPlayerTimeSliderController
    extends ValueNotifier<TimeSliderValue> {
  ApiVideoPlayerTimeSliderController() : super(const TimeSliderValue());

  Duration get currentTime => value.currentTime;

  set currentTime(Duration newCurrentTime) {
    value = value.copyWith(
      currentTime: newCurrentTime,
    );
  }

  Duration get duration => value.duration;

  set duration(Duration newDuration) {
    value = value.copyWith(
      duration: newDuration,
    );
  }
}

class ApiVideoPlayerTimeSlider extends StatefulWidget {
  const ApiVideoPlayerTimeSlider.raw(
      {super.key,
      required this.controller,
      required this.style,
      this.onChanged});

  final ApiVideoPlayerTimeSliderController controller;

  final ApiVideoPlayerTimeSliderStyle style;

  final ValueChanged<Duration>? onChanged;

  factory ApiVideoPlayerTimeSlider({
    required ApiVideoPlayerTimeSliderController controller,
    ApiVideoPlayerTimeSliderStyle? style,
    ValueChanged<Duration>? onChanged,
  }) {
    style ??= ApiVideoPlayerTimeSliderStyle();
    return ApiVideoPlayerTimeSlider.raw(
      controller: controller,
      style: style,
      onChanged: onChanged,
    );
  }

  @override
  State<ApiVideoPlayerTimeSlider> createState() =>
      _ApiVideoPlayerTimeSliderState();
}

class _ApiVideoPlayerTimeSliderState extends State<ApiVideoPlayerTimeSlider> {
  Duration _currentTime = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_didChangeTimeSliderValue);
    if (mounted) {
      setState(() {
        _currentTime = widget.controller.currentTime;
        _duration = widget.controller.duration;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeTimeSliderValue);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
            flex: 9,
            child: SliderTheme(
                data: widget.style.sliderTheme,
                child: Slider(
                  value: max(
                      0,
                      min(
                        widget.controller.currentTime.inMilliseconds,
                        widget.controller.duration.inMilliseconds,
                      )).toDouble(),
                  // Ensure that the slider doesn't go over the duration or under 0.0
                  min: 0.0,
                  max: widget.controller.duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    final Duration currentTime =
                        Duration(milliseconds: value.toInt());
                    if (currentTime == widget.controller.currentTime) {
                      return;
                    }
                    widget.controller.currentTime = currentTime;
                    if (widget.onChanged != null) {
                      widget.onChanged!(currentTime);
                    }
                  },
                ))),
        Flexible(
            flex: 1,
            child: Text((_duration - _currentTime).toPlayerString(),
                textAlign: TextAlign.center,
                style: widget.style.sliderTheme.valueIndicatorTextStyle)),
      ],
    );
  }

  void _didChangeTimeSliderValue() {
    if (mounted) {
      setState(() {
        _currentTime = widget.controller.currentTime;
        _duration = widget.controller.duration;
      });
    }
  }
}

class ApiVideoPlayerTimeSliderStyle {
  const ApiVideoPlayerTimeSliderStyle.raw({required this.sliderTheme});

  final SliderThemeData sliderTheme;

  factory ApiVideoPlayerTimeSliderStyle({SliderThemeData? sliderTheme}) {
    sliderTheme ??= const SliderThemeData();
    return ApiVideoPlayerTimeSliderStyle.raw(sliderTheme: sliderTheme);
  }

  static ApiVideoPlayerTimeSliderStyle of(BuildContext context) {
    final SliderThemeData sliderTheme = SliderTheme.of(context);
    return ApiVideoPlayerTimeSliderStyle(sliderTheme: sliderTheme);
  }
}
