import 'dart:async';

import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter/material.dart';

class ApiVideoPlayerOverlayController extends ChangeNotifier {
  bool isOverlayVisible;
  bool isSelectedSpeedRateListViewVisible;
  final ApiVideoPlayerController _controller;
  ApiVideoPlayerOverlayController({
    required ApiVideoPlayerController controller,
    required this.isOverlayVisible,
    required this.isSelectedSpeedRateListViewVisible,
  }) : _controller = controller;

  Timer? _overlayVisibilityTimer;
  @override
  void dispose() {
    _overlayVisibilityTimer?.cancel();
    super.dispose();
  }

  void showOverlayForDuration() {
    if (!isOverlayVisible) {
      showOverlay();
    }
    if (isSelectedSpeedRateListViewVisible) {
      _hideSpeedRateListView();
    }
    _overlayVisibilityTimer?.cancel();
    _overlayVisibilityTimer = Timer(const Duration(seconds: 5), hideOverlay);
  }

  void showOverlay() {
    isOverlayVisible = true;
    notifyListeners();
  }

  void hideOverlay() {
    isOverlayVisible = false;
    isSelectedSpeedRateListViewVisible = false;
    notifyListeners();
  }

  void _hideSpeedRateListView() {
    isSelectedSpeedRateListViewVisible = false;
  }
}
