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
  bool isPlaying = false;

//TODO: remove this method to use controller's
  pause() {
    widget.controller.pause();
    setState(() {
      isPlaying = false;
    });
  }

//TODO: remove this method to use controller's
  play() {
    widget.controller.play();
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        // TODO: use method from controller
        onTap: () => isPlaying ? pause() : play(),
        child: Stack(
          children: <Widget>[
            buildPlayPause(),
          ],
        ),
      );

  Widget buildPlayPause() => isPlaying
      ? Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                  onPressed: () {
                    // TODO: seek backward
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 30,
                  icon:
                      const Icon(Icons.replay_10_rounded, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    pause();
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 60,
                  // TODO: Change icon to api's one
                  icon: const Icon(Icons.pause_circle_filled_rounded,
                      color: Colors.white)),
              IconButton(
                  onPressed: () {
                    // TODO: seek forward
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 30,
                  icon: const Icon(Icons.forward_10_rounded,
                      color: Colors.white)),
            ],
          ),
        )
      : Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                  onPressed: () {
                    // TODO: seek backward
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 30,
                  icon:
                      const Icon(Icons.replay_10_rounded, color: Colors.white)),
              IconButton(
                  onPressed: () {
                    play();
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 60,
                  // TODO: Change icon to api's one
                  icon: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white)),
              IconButton(
                  onPressed: () {
                    // TODO: seek forward
                  },
                  color: Colors.cyanAccent,
                  constraints: const BoxConstraints(maxHeight: 36),
                  iconSize: 30,
                  icon: const Icon(Icons.forward_10_rounded,
                      color: Colors.white)),
            ],
          ),
        );
}
