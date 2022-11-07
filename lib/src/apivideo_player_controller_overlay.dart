import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../apivideo_player.dart';

class ApiVideoPlayerControllerOverlay extends StatefulWidget {
  final ApiVideoPlayerController controller;

  const ApiVideoPlayerControllerOverlay({
    super.key,
    required this.controller,
  });

  @override
  State<ApiVideoPlayerControllerOverlay> createState() =>
      _ApiVideoPlayerControllerOverlayState();
}

class _ApiVideoPlayerControllerOverlayState
    extends State<ApiVideoPlayerControllerOverlay> {
  _ApiVideoPlayerControllerOverlayState() {
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
  bool isOverlayDisplayed = true;
  late var timer = startTimeout();
  String remainingTimeText = "00:00";

  @override
  initState() {
    super.initState();
    widget.controller.addListener(_listener);
    remainingTime();
  }

  pause() {
    widget.controller.pause();
    hideAndSeekOverlay();
  }

  play() {
    widget.controller.play();
    hideAndSeekOverlay();
  }

  seek(Duration duration) {
    widget.controller.seek(duration);
    hideAndSeekOverlay();
  }

  // Hide and seek overlay
  hideAndSeekOverlay() {
    if (!isOverlayDisplayed) {
      setState(() {
        isOverlayDisplayed = true;
      });
    }
    timer.cancel();
    timer = startTimeout();
  }

  void handleTimeout() {
    setState(() {
      isOverlayDisplayed = false;
    });
  }

  startTimeout() {
    return Timer(const Duration(seconds: 5), handleTimeout);
  }

  //remaining time
  remainingTime() async {
    Duration duration = await widget.controller.duration;
    print('duration --------  $duration');
    var currentTime = await widget.controller.currentTime;

    var remaining = duration - currentTime;
    setState(() {
      remainingTimeText = remaining.toString().split('.').first;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          hideAndSeekOverlay();
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
        visible: isOverlayDisplayed,
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
        visible: isOverlayDisplayed,
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
              Text(remainingTimeText,
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );
}
