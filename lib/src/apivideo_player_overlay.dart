import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../apivideo_player.dart';

class ApiVideoPlayerOverlay extends StatefulWidget {
  final ApiVideoPlayerController controller;

  const ApiVideoPlayerOverlay({
    super.key,
    required this.controller,
  });

  @override
  State<ApiVideoPlayerOverlay> createState() => _ApiVideoPlayerOverlayState();
}

class _ApiVideoPlayerOverlayState extends State<ApiVideoPlayerOverlay> {
  _ApiVideoPlayerOverlayState() {
    _listener = ApiVideoPlayerEventsListener(
      onReady: () async {
        _updateDuration();
      },
      onPlay: () {
        _startRemainingTimeUpdates();
        setState(() {
          _isPlaying = true;
        });
      },
      onPause: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
        });
      },
      onSeek: () {
        _updateCurrentTime();
      },
      onEnd: () {
        _stopRemainingTimeUpdates();
        setState(() {
          _isPlaying = false;
        });
      },
    );
  }

  bool _isPlaying = false;

  late ApiVideoPlayerEventsListener _listener;

  Timer? _timeSliderTimer;

  bool _isOverlayVisible = true;
  Timer? _overlayVisibilityTimer;

  Duration _currentTime = const Duration(seconds: 0);
  Duration _duration = const Duration(seconds: 0);

  @override
  initState() {
    super.initState();
    widget.controller.addEventsListener(_listener);
    _showOverlayForDuration();
    _updateCurrentTime();
    _updateDuration();
    widget.controller.isPlaying.then((isPlaying) => {
          if (isPlaying) {_onPlay()}
        });
  }

  @override
  void dispose() {
    widget.controller.removeEventsListener(_listener);
    _overlayVisibilityTimer?.cancel();
    _stopRemainingTimeUpdates();
    super.dispose();
  }

  void pause() {
    widget.controller.pause();
    _showOverlayForDuration();
  }

  void play() {
    widget.controller.play();
    _showOverlayForDuration();
  }

  void seek(Duration duration) {
    widget.controller.seek(duration);
    _showOverlayForDuration();
  }

  void setCurrentTime(Duration duration) {
    widget.controller.setCurrentTime(duration);
    _showOverlayForDuration();
  }

  void _showOverlayForDuration() {
    if (!_isOverlayVisible) {
      showOverlay();
    }
    _overlayVisibilityTimer?.cancel();
    _overlayVisibilityTimer = Timer(const Duration(seconds: 5), hideOverlay);
  }

  void showOverlay() {
    setState(() {
      _isOverlayVisible = true;
    });
  }

  void hideOverlay() {
    setState(() {
      _isOverlayVisible = false;
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
  }

  void _onPlay() {
    _startRemainingTimeUpdates();
    setState(() {
      _isPlaying = true;
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

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => showOverlay(),
    onExit: (_) => _showOverlayForDuration(),
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _showOverlayForDuration();
      },
      child: buildOverlay(),
    ),
  );

  Widget buildOverlay() => Visibility(
      visible: _isOverlayVisible,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 30,
          ),
          buildControls(),
          buildSlider(),
        ],
      ));

  Widget buildControls() => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  seek(const Duration(seconds: -10));
                },
                iconSize: 30,
                icon: const Icon(Icons.replay_10_rounded, color: Colors.white)),
            buildBtnPlay(),
            IconButton(
                onPressed: () {
                  seek(const Duration(seconds: 10));
                },
                iconSize: 30,
                icon:
                    const Icon(Icons.forward_10_rounded, color: Colors.white)),
          ],
        ),
      );

  Widget buildBtnPlay() {
    return IconButton(
        onPressed: () {
          _isPlaying ? pause() : play();
        },
        iconSize: 60,
        // TODO: Change icon to api's one
        icon: _isPlaying
            ? const Icon(Icons.pause_circle_filled_rounded, color: Colors.white)
            : const Icon(Icons.play_arrow_rounded, color: Colors.white));
  }

  Widget buildSlider() => Container(
        height: 60,
        padding: const EdgeInsets.only(right: 5),
        child: Row(
          children: [
            Expanded(
              child: Slider(
                value: min(
                        _currentTime.inMilliseconds,
                        _duration
                            .inMilliseconds) // Ensure that the slider doesn't go over the duration
                    .toDouble(),
                max: _duration.inMilliseconds.toDouble(),
                activeColor: Colors.orangeAccent,
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  setCurrentTime(Duration(milliseconds: value.toInt()));
                },
              ),
            ),
            Text((_duration - _currentTime).toPlayerString(),
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      );
}

extension DurationDisplay on Duration {
  String toPlayerString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    if (inHours > 0) {
      return "$inHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
