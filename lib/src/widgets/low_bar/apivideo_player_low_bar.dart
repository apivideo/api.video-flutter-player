import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/style/apivideo_label.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerLowBarController {
  final _timeSliderController = ApiVideoPlayerTimeSliderController();

  Duration get currentTime => _timeSliderController.currentTime;

  set currentTime(Duration newCurrentTime) {
    _timeSliderController.currentTime = newCurrentTime;
  }

  Duration get duration => _timeSliderController.duration;

  set duration(Duration newDuration) {
    _timeSliderController.duration = newDuration;
  }
}

class ApiVideoPlayerLowBar extends StatefulWidget {
  const ApiVideoPlayerLowBar(
      {super.key,
      required this.controller,
      required this.onSpeedRatePress,
      required this.onTimeSliderChanged,
      this.activeColor,
      this.inactiveColor,
      this.thumbColor,
      this.textColor,
      this.iconsColor});

  final ApiVideoPlayerLowBarController controller;

  final VoidCallback onSpeedRatePress;
  final ValueChanged<Duration> onTimeSliderChanged;

  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final Color? textColor;
  final Color? iconsColor;

  @override
  State<ApiVideoPlayerLowBar> createState() => _ApiVideoPlayerLowBarState();
}

class _ApiVideoPlayerLowBarState extends State<ApiVideoPlayerLowBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.only(right: 10, left: 10),
      child: Column(
        children: [
          buildBottomAction(),
          buildTimeSlider(),
        ],
      ),
    );
  }

  Widget buildBottomAction() => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                widget.onSpeedRatePress();
              },
              iconSize: 25,
              icon: Icon(
                Icons.speed,
                color: widget.iconsColor ??
                    ApiVideoPlayerTheme.defaultTheme.iconsColor,
                semanticLabel: ApiVideoPlayerLabel.playbackRate,
              ),
            ),
          ],
        ),
      );

  Widget buildTimeSlider() => ApiVideoPlayerTimeSlider(
        controller: widget.controller._timeSliderController,
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        thumbColor: widget.thumbColor,
        textColor: widget.textColor,
        onChanged: (Duration value) {
          widget.onTimeSliderChanged(value);
        },
      );
}
