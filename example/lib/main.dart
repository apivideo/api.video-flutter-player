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
  final TextEditingController _textEditingController =
      TextEditingController(text: '');
  ApiVideoPlayerController? _controller;
  String _duration = 'Get duration';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter a video id',
                  ),
                  controller: _textEditingController,
                  onSubmitted: (value) async {
                    if (_controller == null) {
                      setState(() {
                        _controller = ApiVideoPlayerController(
                          videoOptions: VideoOptions(videoId: value),
                          onReady: () => setState(() {
                            _duration = 'Get duration';
                          }),
                        );
                      });
                      return;
                    }
                    _controller?.setVideoOptions(VideoOptions(videoId: value));
                  },
                ),
              ),
              _controller != null
                  ? PlayerWidget(
                      controller: _controller!,
                      duration: _duration,
                      setDuration: (String duration) => setState(() {
                        _duration = duration;
                      }),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    super.key,
    required this.controller,
    required this.duration,
    required this.setDuration,
  });

  final ApiVideoPlayerController controller;
  final String duration;
  final void Function(String duration) setDuration;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String _currentTime = 'Get current time';

  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ApiVideoPlayer(controller: widget.controller),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: const Icon(Icons.replay_10),
            onPressed: () {
              widget.controller.seek(const Duration(seconds: -10));
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              widget.controller.play();
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              widget.controller.pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.forward_10),
            onPressed: () {
              widget.controller.seek(const Duration(seconds: 10));
            },
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.volume_off),
              onPressed: () {
                widget.controller.setIsMuted(true);
              },
            ),
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: () {
                widget.controller.setIsMuted(false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.loop),
              onPressed: () {
                widget.controller.isLooping.then(
                  (bool value) {
                    widget.controller.setIsLooping(!value);
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
        TextButton(
          child: Text(
            widget.duration,
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            final Duration duration = await widget.controller.duration;
            widget.setDuration(
              'Duration: $duration',
            );
          },
        ),
        TextButton(
          child: Text(_currentTime),
          onPressed: () async {
            final Duration currentTime = await widget.controller.currentTime;
            setState(() {
              _currentTime = 'Get current time: $currentTime';
            });
          },
        ),
      ],
    );
  }
}
