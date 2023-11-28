import 'package:flutter/cupertino.dart';

import '../apivideo_player.dart';

/// The player life cycle observer.
/// It pauses the player when the app is paused.
/// It resumes the player when the app is resumed (if the player was playing before).
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
      default:
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
