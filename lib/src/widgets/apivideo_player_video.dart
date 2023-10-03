import 'package:apivideo_player/src/apivideo_player_controller.dart';
import 'package:apivideo_player/src/platform/apivideo_player_platform_interface.dart';
import 'package:flutter/material.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

/// A stack containing the video and a child widget.
class PlayerVideo extends StatefulWidget {
  const PlayerVideo({super.key, required this.controller, this.child});

  final ApiVideoPlayerController controller;
  final Widget? child;

  @override
  State<PlayerVideo> createState() => _PlayerVideoState();
}

class _PlayerVideoState extends State<PlayerVideo> {
  _PlayerVideoState() {
    _widgetListener =
        ApiVideoPlayerControllerWidgetListener(onTextureReady: () async {
      _updateTextureId();
    });
    _eventsListener = ApiVideoPlayerControllerEventsListener(onReady: () async {
      _updateAspectRatio();
    });
  }

  late ApiVideoPlayerControllerEventsListener _eventsListener;
  late ApiVideoPlayerControllerWidgetListener _widgetListener;
  late int _textureId = widget.controller.textureId;
  double _aspectRatio = 1.0;

  @override
  void initState() {
    super.initState();
    widget.controller.addWidgetListener(_widgetListener);
    widget.controller.addListener(_eventsListener);
    // In case controller is already created
    widget.controller.isCreated.then((bool isCreated) => {
          if (isCreated) {_updateAspectRatio()}
        });
  }

  @override
  void didUpdateWidget(PlayerVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeWidgetListener(_widgetListener);
    oldWidget.controller.removeListener(_eventsListener);
    widget.controller.addWidgetListener(_widgetListener);
    widget.controller.addListener(_eventsListener);
  }

  @override
  void dispose() {
    widget.controller.removeWidgetListener(_widgetListener);
    widget.controller.removeListener(_eventsListener);
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
              children: [
                _playerPlatform.buildView(_textureId),
                Positioned.fill(child: widget.child ?? Container()),
              ],
            )),
      );

  void _updateAspectRatio() async {
    final size = await widget.controller.videoSize;
    final double newAspectRatio = size?.aspectRatio ?? 1.0;
    if (newAspectRatio != _aspectRatio) {
      if (mounted) {
        setState(() {
          _aspectRatio = newAspectRatio;
        });
      }
    }
  }

  void _updateTextureId() async {
    final int newTextureId = widget.controller.textureId;
    if (newTextureId != _textureId) {
      if (mounted) {
        setState(() {
          _textureId = newTextureId;
        });
      }
    }
  }
}
