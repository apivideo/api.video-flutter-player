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
      VideoOptions(videoId: 'vi3CjYlusQKz6JN7au0EmW9b'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ApiVideoPlayer(
              controller: _controller,
            ),
            // const Text("FOO"),
            // const Text("BAR"),
          ],
        ),
      ),
    );
  }
}
