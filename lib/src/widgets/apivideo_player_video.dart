import 'package:apivideo_player/src/apivideo_player_controller.dart';
import 'package:apivideo_player/src/platform/apivideo_player_platform_interface.dart';
import 'package:flutter/material.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

/// A stack containing the video and a child widget.
class PlayerVideo extends StatefulWidget {
  const PlayerVideo(
      {super.key,
      required this.controller,
      this.fit = BoxFit.contain,
      this.child});

  /// The controller for the player.
  final ApiVideoPlayerController controller;

  /// The fit for the video. The overlay is not affected.
  final BoxFit fit;

  /// The child widget to display as an overlay on top of the video.
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

  double _aspectRatio = 1.77;
  Size _size = const Size(1280, 720);

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

  Widget buildPlayer() => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(alignment: Alignment.center, children: [
          // See https://github.com/flutter/flutter/issues/17287
          SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: FittedBox(
                  fit: widget.fit,
                  clipBehavior: Clip.hardEdge,
                  child: Center(
                      child: SizedBox(
                          width: _size.width,
                          height: _size.height,
                          child: _playerPlatform.buildView(_textureId))))),
          buildFittedPlayerOverlay(constraints)
        ]);
      });

  Widget buildFittedPlayerOverlay(BoxConstraints constraints) {
    final fittedSize = applyBoxFit(widget.fit, _size, constraints.biggest);
    return SizedBox(
        width: fittedSize.destination.width,
        height: fittedSize.destination.height,
        child: widget.child ?? Container());
  }

  void _updateAspectRatio() async {
    final newSize = await widget.controller.videoSize ?? const Size(1280, 720);
    final double newAspectRatio = newSize.aspectRatio;
    if ((newAspectRatio != _aspectRatio) || (newSize != _size)) {
      if (mounted) {
        setState(() {
          _size = newSize;
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
