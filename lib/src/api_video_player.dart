import 'package:api_video_player/src/api_video_player_overlay.dart';
import 'package:flutter/material.dart';

import 'api_video_player_controller.dart';
import 'api_video_player_platform_interface.dart';

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
    });
  }

  late ApiVideoPlayerEventsListener _eventsListener;
  late ApiVideoPlayerWidgetListener _widgetListener;
  late int _textureId;
  double _aspectRatio = 1.0;

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

/// A customizable theme for the player.
///
/// ```dart
/// final PlayerTheme theme = const PlayerTheme(
///   controlsColor: Colors.yellow,
///   activeTimeSliderColor: Colors.blue,
///   inactiveTimeSliderColor: Colors.red,
/// );
/// ```
class PlayerTheme {
  const PlayerTheme({
    this.controlsColor = Colors.white,
    this.activeTimeSliderColor = ApiVideoColors.orange,
    this.inactiveTimeSliderColor = Colors.grey,
    this.activeVolumeSliderColor = Colors.white,
    this.inactiveVolumeSliderColor = Colors.grey,
  });

  final Color controlsColor;
  final Color activeTimeSliderColor;
  final Color inactiveTimeSliderColor;
  final Color activeVolumeSliderColor;
  final Color inactiveVolumeSliderColor;
}
