import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

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
  final TextEditingController _tokenTextEditingController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
  }

  void setVideoOption() {
    if (_tokenTextEditingController.text.isEmpty) {
      if (_controller == null) {
        setState(() {
          _controller = ApiVideoPlayerController(
            videoOptions: VideoOptions(videoId: _textEditingController.text),
          );
        });
      } else {
        _controller?.setVideoOptions(
            VideoOptions(videoId: _textEditingController.text));
      }
    } else {
      if (_controller == null) {
        setState(() {
          _controller = ApiVideoPlayerController(
            videoOptions: VideoOptions(
                videoId: _textEditingController.text,
                token: _tokenTextEditingController.text),
          );
        });
      } else {
        _controller?.setVideoOptions(VideoOptions(
            videoId: _textEditingController.text,
            token: _tokenTextEditingController.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFA5B30),
          ),
        ),
      ),
      home: Builder(builder: (context) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
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
                        setVideoOption();
                      },
                    ),
                  ),
                  // add a switch btn to set private or public video
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText:
                            'Enter a token (leave empty if the video is public)',
                      ),
                      controller: _tokenTextEditingController,
                      onSubmitted: (value) async {
                        setVideoOption();
                      },
                    ),
                  ),
                  _controller != null
                      ? PlayerWidget(controller: _controller!)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
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
  });

  final ApiVideoPlayerController controller;

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String _currentTime = 'Get current time';
  String _duration = 'Get duration';
  bool _hideControls = false;

  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
    widget.controller.addEventsListener(ApiVideoPlayerEventsListener(
      onReady: () {
        setState(() {
          _duration = 'Get duration';
        });
      },
    ));
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void _toggleLooping() {
    widget.controller.isLooping.then(
      (bool isLooping) {
        widget.controller.setIsLooping(!isLooping);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Your video is ${isLooping ? 'not on loop anymore' : 'on loop'}.',
            ),
            backgroundColor: Colors.blueAccent,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: 400.0,
          height: 300.0,
          child: ApiVideoPlayer(
            controller: widget.controller,
            hideControls: _hideControls,
          ),
        ),
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
              onPressed: () => _toggleLooping(),
            ),
          ],
        ),
        TextButton(
          child: Text(
            _duration,
            textAlign: TextAlign.center,
          ),
          onPressed: () async {
            final Duration duration = await widget.controller.duration;
            setState(() {
              _duration = 'Duration: $duration';
            });
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
        TextButton(
          child: Text('${_hideControls ? 'Show' : 'Hide'} controls'),
          onPressed: () => setState(() {
            _hideControls = !_hideControls;
          }),
        ),
      ],
    );
  }
}
