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
    autoplay: true,
  );
  String? _duration;
  String _currentTime = 'Get current time';
  VideoOptions? _videoOptions;

  @override
  void initState() {
    super.initState();
    _controller.initialize().then((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              ApiVideoPlayer(controller: _controller),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  icon: const Icon(Icons.replay_10),
                  onPressed: () {
                    _controller.seek(const Duration(seconds: -10));
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
                    _controller.seek(const Duration(seconds: 10));
                  },
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  IconButton(
                    icon: const Icon(Icons.loop),
                    onPressed: () {
                      _controller.isLooping.then(
                        (bool value) {
                          _controller.setIsLooping(!value);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Your video is ${value ? 'not on loop anymore' : 'on loop'}.',
                              ),
                              backgroundColor: Colors.blueAccent,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
              _duration != null
                  ? Text(
                      _duration!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    )
                  : TextButton(
                      child: const Text(
                        'Get duration',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () async {
                        final duration = await _controller.duration;
                        setState(() {
                          _duration =
                              'Your video has a duration of ${duration.inHours.toString()} hours, ${duration.inMinutes.toString()} minutes, ${duration.inSeconds.toString()} seconds and ${duration.inMilliseconds.toString()} milliseconds';
                        });
                      },
                    ),
              TextButton(
                child: Text(_currentTime),
                onPressed: () async {
                  final Duration currentTime = await _controller.currentTime;
                  setState(() {
                    _currentTime = 'Get current time: $currentTime';
                  });
                },
              ),
              _videoOptions != null
                  ? Text(
                      'Current video\'s id: ${_videoOptions!.videoId}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                    )
                  : TextButton(
                      child: const Text('Get current video\'s id'),
                      onPressed: () async {
                        final VideoOptions videoOptions =
                            await _controller.videoOptions;
                        setState(() {
                          _videoOptions = videoOptions;
                        });
                      },
                    ),
            ],
          ),
        );
      }),
    );
  }
}
