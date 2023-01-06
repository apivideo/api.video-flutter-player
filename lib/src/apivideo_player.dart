import 'dart:html';

import 'package:apivideo_player/src/apivideo_player_overlay.dart';
import 'package:apivideo_player/src/apivideo_player_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apivideo_player_controller.dart';
import 'apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

/// The player widget.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return ApiVideoPlayer(
///     controller: controller,
///   )
/// }
/// ```
class ApiVideoPlayer extends StatefulWidget {
  const ApiVideoPlayer({
    super.key,
    required this.controller,
    this.hideControls = false,
    this.theme = const PlayerTheme(),
  });

  final ApiVideoPlayerController controller;
  final bool hideControls;
  final PlayerTheme theme;

  @override
  State<ApiVideoPlayer> createState() => _ApiVideoPlayerState();
}

class _ApiVideoPlayerState extends State<ApiVideoPlayer> {
  _ApiVideoPlayerState() {
    _widgetListener = ApiVideoPlayerWidgetListener(onTextureReady: () {
      final int newTextureId = widget.controller.textureId;
      if (newTextureId != _textureId) {
        setState(() {
          _textureId = newTextureId;
        });
      }
    });
    _eventsListener = ApiVideoPlayerEventsListener(onReady: () async {
      _updateAspectRatio();
    }, onFullscreenChange: () {
      final bool isFullscreen = widget.controller.isFullscreen;
      if (!isFullscreen) {
        _exitFullscreen();
      } else {
        _enterFullscreen();
      }
    });
  }

  late ApiVideoPlayerEventsListener _eventsListener;
  late ApiVideoPlayerWidgetListener _widgetListener;
  OverlayEntry? _overlayEntry;
  late int _textureId;
  double _aspectRatio = 1.0;
  int foo = 0;

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) => {
          if (isCreated) {_updateAspectRatio()}
        });
    widget.controller.addWidgetListener(_widgetListener);
    widget.controller.addEventsListener(_eventsListener);
  }

  @override
  void dispose() {
    widget.controller.removeWidgetListener(_widgetListener);
    widget.controller.removeEventsListener(_eventsListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _textureId == ApiVideoPlayerController.kUninitializedTextureId
        ? Container()
        : buildPlayer();
  }

  Widget buildPlayer() => Center(
        child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: Stack(
              children: <Widget>[
                _playerPlatform.buildView(_textureId),
                Positioned.fill(
                  child: ApiVideoPlayerOverlay(
                    controller: widget.controller,
                    hideControls: widget.hideControls,
                    theme: widget.theme,
                  ),
                ),
              ],
            )),
      );

  _enterFullscreen() async {
    if (kIsWeb) {
      await _playerPlatform.enterFullScreen(_textureId);
      document.documentElement?.requestFullscreen();
    }
    _overlayEntry = OverlayEntry(builder: (context) {
      return Scaffold(
        body: Center(
          child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: Stack(
                children: <Widget>[
                  _playerPlatform.buildView(_textureId),
                  Positioned.fill(
                    child: ApiVideoPlayerOverlay(
                      controller: widget.controller,
                      hideControls: widget.hideControls,
                      theme: widget.theme,
                    ),
                  ),
                ],
              )),
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry!);
  }

  _exitFullscreen() async {
    if (kIsWeb) {
      // TODO: Ajouter un flag en JS pour capter textureId
      await _playerPlatform.exitFullScreen(_textureId);
      widget.controller.initialize();
      document.exitFullscreen();
    }
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateAspectRatio() async {
    final size = await widget.controller.videoSize;
    final double newAspectRatio = size?.aspectRatio ?? 1.0;
    if (newAspectRatio != _aspectRatio) {
      setState(() {
        _aspectRatio = newAspectRatio;
      });
    }
  }
}
