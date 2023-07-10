import 'dart:async';
import 'dart:math';
import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_overlay.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerTimeSliderView extends StatefulWidget {
  const ApiVideoPlayerTimeSliderView(
      {super.key, required this.controller, required this.theme});

  final ApiVideoPlayerController controller;
  final PlayerTheme theme;

  @override
  State<ApiVideoPlayerTimeSliderView> createState() =>
      _ApiVideoPlayerTimeSliderViewState();
}

class _ApiVideoPlayerTimeSliderViewState
    extends State<ApiVideoPlayerTimeSliderView> {
  _ApiVideoPlayerTimeSliderViewState() {
    _listener = ApiVideoPlayerEventsListener(
      onReady: () async {
        _updateCurrentTime();
        _updateDuration();
      },
      onPlay: () {
        _startRemainingTimeUpdates();
      },
      onPause: () {
        _stopRemainingTimeUpdates();
      },
      onSeek: () {
        _updateCurrentTime();
      },
      onSeekStarted: () {},
      onEnd: () {},
    );
  }

  late ApiVideoPlayerEventsListener _listener;
  Duration _currentTime = const Duration(seconds: 0);
  Duration _duration = const Duration(seconds: 0);
  Timer? _timeSliderTimer;

  void setCurrentTime(Duration duration) async {
    await widget.controller.setCurrentTime(duration);
    setState(() {
      _currentTime = duration;
    });
  }

  void _updateCurrentTime() async {
    Duration currentTime = await widget.controller.currentTime;
    setState(() {
      _currentTime = currentTime;
    });
  }

  void _updateDuration() async {
    Duration duration = await widget.controller.duration;
    setState(() {
      _duration = duration;
    });
  }

  void _startRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => _updateCurrentTime(),
    );
  }

  void _stopRemainingTimeUpdates() {
    _timeSliderTimer?.cancel();
    _timeSliderTimer = null;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener(_listener);
    _stopRemainingTimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _updateCurrentTime();
    _updateDuration();
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Slider(
              value: max(
                  0,
                  min(
                    _currentTime.inMilliseconds,
                    _duration.inMilliseconds,
                  )).toDouble(),
              // Ensure that the slider doesn't go over the duration or under 0.0
              min: 0.0,
              max: _duration.inMilliseconds.toDouble(),
              activeColor: widget.theme.activeTimeSliderColor,
              inactiveColor: widget.theme.inactiveTimeSliderColor,
              onChanged: (value) {
                // widget.onChanged(value);
                setCurrentTime(Duration(milliseconds: value.toInt()));
              },
            ),
          ),
          Text((_duration - _currentTime).toPlayerString(),
              style: TextStyle(color: widget.theme.controlsColor)),
        ],
      ),
    );
  }
}
