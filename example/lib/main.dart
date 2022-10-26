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
  final List<String> videosId = [
    'vi6f1aAj2xdDaPrHz8hrDiZC',
    'vi3CjYlusQKz6JN7au0EmW9b'
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ...videosId.map((e) => buildPreview(
                controller:
                    ApiVideoPlayerController(VideoOptions(videoId: e)))),
          ],
        ),
      ),
    );
  }

  Future<int> initialize(ApiVideoPlayerController controller) async {
    await controller.initialize();
    return 0;
  }

  Widget buildPreview({required ApiVideoPlayerController controller}) {
    // Wait for [LiveStreamController.create] to finish.
    return FutureBuilder<void>(
        future: initialize(controller),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                ApiVideoPlayer(controller: controller),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        controller.play();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause),
                      onPressed: () {
                        controller.pause();
                      },
                    ),
                  ],
                ),
              ],
            );
          }
        });
  }
}
