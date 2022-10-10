import 'package:apivideo_player/apivideo_player_controller.dart';
import 'package:apivideo_player/apivideo_types.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:apivideo_player/apivideo_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _onViewCreated(ApiVideoPlayerController controller) {
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ApiVideoPlayer(videoId: 'vi3CjYlusQKz6JN7au0EmW9b', videoType: VideoType.vod, onViewCreated: _onViewCreated),
        ),
      ),
    );
  }
}
