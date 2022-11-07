import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ApiVideoPlayerController _controller = ApiVideoPlayerController(
    videoOptions: VideoOptions(videoId: 'vi3CjYlusQKz6JN7au0EmW9b'),
  );

  @override
  void initState() {
    super.initState();
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ApiVideoPlayer(controller: _controller),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  _controller.seek(Duration(seconds: -10));
                },
              ),
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () {
                  _controller.play();
                },
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  _controller.pause();
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  _controller.seek(Duration(seconds: 10));
                },
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_off),
                  onPressed: () {
                    _controller.setIsMuted(true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    _controller.setIsMuted(false);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
