import 'package:flutter/cupertino.dart';

import '../apivideo_player.dart';

class PlayerLifeCycleObserver extends Object with WidgetsBindingObserver {
  final ApiVideoPlayerController controller;
  bool _wasPlayingBeforePause = false;

  PlayerLifeCycleObserver(this.controller);

  void initialize() {
    _ambiguate(WidgetsBinding.instance)!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (_wasPlayingBeforePause) {
          controller.play();
        }
        break;
      case AppLifecycleState.paused:
        pause();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void pause() async {
    _wasPlayingBeforePause = await controller.isPlaying;
    controller.pause();
  }

  void dispose() {
    _ambiguate(WidgetsBinding.instance)!.removeObserver(this);
  }
}

T? _ambiguate<T>(T? value) => value;
