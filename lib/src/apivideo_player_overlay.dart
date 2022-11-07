import 'dart:async';

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
    _listener = ApiVideoPlayerControllerListener(
      onReady: () {
        setState(() {});
      },
      onPlay: () {
        setState(() {
          isPlaying = true;
        });
      },
      onPause: () {
        setState(() {
          isPlaying = false;
        });
      },
      onSeek: () {
        setState(() {});
      },
      onEnd: () {
        setState(() {
          isPlaying = false;
        });
      },
    );
  }

  bool isPlaying = false;

  late ApiVideoPlayerControllerListener _listener;

  bool isOverlayVisible = true;
  Timer? overlayVisibilityTimer;

  Duration remainingDuration = const Duration(seconds: 0);

  @override
  initState() {
    super.initState();
    widget.controller.addListener(_listener);
    _showOverlayForDuration();
    _updateRemainingTime();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    overlayVisibilityTimer?.cancel();
    super.dispose();
  }

  pause() {
    widget.controller.pause();
    _showOverlayForDuration();
  }

  play() {
    widget.controller.play();
    _showOverlayForDuration();
  }

  seek(Duration duration) {
    widget.controller.seek(duration);
    _showOverlayForDuration();
  }

  void _showOverlayForDuration() {
    if (!isOverlayVisible) {
      showOverlay();
    }
    overlayVisibilityTimer?.cancel();
    overlayVisibilityTimer =
        _createTimer(const Duration(seconds: 5), hideOverlay);
  }

  void showOverlay() {
    setState(() {
      isOverlayVisible = true;
    });
  }

  void hideOverlay() {
    setState(() {
      isOverlayVisible = false;
    });
  }

  Timer _createTimer(Duration duration, Function() callback) {
    return Timer(duration, callback);
  }

  void _updateRemainingTime() async {
    Duration duration = await widget.controller.duration;
    Duration currentTime = await widget.controller.currentTime;

    setState(() {
      remainingDuration = duration - currentTime;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _showOverlayForDuration();
        },
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 30,
                ),
                controls(),
                buildSlider(),
              ],
            ),
          ],
        ),
      );

  Widget controls() => Visibility(
        visible: isOverlayVisible,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    seek(const Duration(seconds: -10));
                  },
                  iconSize: 30,
                  icon:
                      const Icon(Icons.replay_10_rounded, color: Colors.white)),
              buildBtnPlay(),
              IconButton(
                  onPressed: () {
                    seek(const Duration(seconds: 10));
                  },
                  iconSize: 30,
                  icon: const Icon(Icons.forward_10_rounded,
                      color: Colors.white)),
            ],
          ),
        ),
      );

  Widget buildBtnPlay() {
    return IconButton(
        onPressed: () {
          isPlaying ? pause() : play();
        },
        iconSize: 60,
        // TODO: Change icon to api's one
        icon: isPlaying
            ? const Icon(Icons.pause_circle_filled_rounded, color: Colors.white)
            : const Icon(Icons.play_arrow_rounded, color: Colors.white));
  }

  Widget buildSlider() => Visibility(
        visible: isOverlayVisible,
        child: Container(
          height: 60,
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            children: [
              Expanded(
                child: Slider(
                  value: 0,
                  activeColor: Colors.orangeAccent,
                  inactiveColor: Colors.grey,
                  onChanged: (value) {
                    seek(Duration(seconds: value.toInt()));
                  },
                ),
              ),
              Text(
                  remainingDuration
                      .toString()
                      .split('.')
                      .first, // TODO: have a better display
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
}
