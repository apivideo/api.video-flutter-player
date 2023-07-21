import 'package:apivideo_player/apivideo_player.dart';
import 'package:apivideo_player/src/controllers/apivideo_player_overlay_controller.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerControlsViewController extends ChangeNotifier {
  final ApiVideoPlayerOverlayController _overlayController;

  ApiVideoPlayerControlsViewController({
    required ApiVideoPlayerOverlayController overlayController,
  }) : _overlayController = overlayController;

  Future<bool> get isCreated => _overlayController.isCreated;

  Future<bool> get isPlaying {
    return _overlayController.isPlaying;
  }

  void play() {
    _overlayController.play();
    notifyListeners();
  }

  void pause() {
    _overlayController.pause();
    notifyListeners();
  }

  Future<void> setCurrentTime(Duration currentTime) {
    return _overlayController.setCurrentTime(currentTime);
  }

  void seek(Duration duration) {
    _overlayController.seek(duration);
    notifyListeners();
  }

  void addEventsListener(ApiVideoPlayerEventsListener listener) {
    _overlayController.addEventsListener(listener);
  }

  void removeEventsListener(ApiVideoPlayerEventsListener listener) {
    _overlayController.removeEventsListener(listener);
  }
}
