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

class TimeSliderController extends ValueNotifier<TimeSliderValue> {
  TimeSliderController() : super(const TimeSliderValue());

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

  setTime(Duration newCurrentTime, Duration newDuration) {
    value = TimeSliderValue(currentTime: newCurrentTime, duration: newDuration);
  }
}

class TimeSlider extends StatefulWidget {
  const TimeSlider.raw(
      {super.key,
      required this.controller,
      required this.style,
      this.onChanged});

  final TimeSliderController controller;

  final TimeSliderStyle style;

  final ValueChanged<Duration>? onChanged;

  factory TimeSlider({
    required TimeSliderController controller,
    TimeSliderStyle? style,
    ValueChanged<Duration>? onChanged,
  }) {
    style ??= TimeSliderStyle();
    return TimeSlider.raw(
      controller: controller,
      style: style,
      onChanged: onChanged,
    );
  }

  @override
  State<TimeSlider> createState() => _TimeSliderState();
}

class _TimeSliderState extends State<TimeSlider> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 4,
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
        Expanded(
            flex: 1,
            child: Text(_getRemainingTime().toPlayerString(),
                maxLines: 1,
                softWrap: false,
                textAlign: TextAlign.center,
                style: widget.style.sliderTheme.valueIndicatorTextStyle)),
      ],
    );
  }

  Duration _getRemainingTime() {
    final remainingTime = _duration - _currentTime;
    if (remainingTime.isNegative) {
      return Duration.zero;
    } else {
      return remainingTime;
    }
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

class TimeSliderStyle {
  const TimeSliderStyle.raw({required this.sliderTheme});

  final SliderThemeData sliderTheme;

  factory TimeSliderStyle({SliderThemeData? sliderTheme}) {
    sliderTheme ??= const SliderThemeData();
    return TimeSliderStyle.raw(sliderTheme: sliderTheme);
  }

  static TimeSliderStyle of(BuildContext context) {
    final SliderThemeData sliderTheme = SliderTheme.of(context);
    return TimeSliderStyle(sliderTheme: sliderTheme);
  }
}
