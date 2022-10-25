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

  pause() {
    widget.controller.pause();
    setState(() {
      isPlaying = false;
    });
    print("isPlaying pause : $isPlaying");
  }

  play() {
    widget.controller.play();
    setState(() {
      isPlaying = true;
    });
    print("isPlaying play : $isPlaying");
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => isPlaying ? pause() : play(),
        child: Stack(
          children: <Widget>[
            buildPlayPause(),
          ],
        ),
      );

  Widget buildPlayPause() => isPlaying
      ? Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    pause();
                  },
                  icon: const Icon(Icons.pause_circle,
                      color: Colors.white, size: 60))
            ],
          ),
        )
      : Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    play();
                  },
                  icon: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 60))
            ],
          ),
        );
}
