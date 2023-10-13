import 'package:apivideo_player/src/apivideo_player_controller.dart';
import 'package:apivideo_player/src/style/apivideo_style.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_opacity.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_overlay.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_video.dart';
import 'package:flutter/material.dart';

/// The main player widget.
/// It displays a [Stack] containing the video and a [child] widget on top.
/// By default, the [child] widget is the [PlayerOverlay] inside a [TimedOpacity].
///
/// Use the [child] to display a custom overlay on top of the video.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return ApiVideoPlayer(
///     controller: controller,
///   )
/// }
/// ```
class ApiVideoPlayer extends StatefulWidget {
  const ApiVideoPlayer(
      {super.key,
      required this.controller,
      this.fit = BoxFit.contain,
      this.style,
      this.child});

  /// Creates a player with api.video style.
  factory ApiVideoPlayer.styleFromApiVideo(
      {Key? key, required ApiVideoPlayerController controller, Widget? child}) {
    return ApiVideoPlayer(
        key: key,
        controller: controller,
        style: PlayerStyle.defaultStyle,
        child: child);
  }

  /// Creates a player without controls.
  factory ApiVideoPlayer.noControls(
      {Key? key, required ApiVideoPlayerController controller}) {
    return ApiVideoPlayer(key: key, controller: controller, child: Container());
  }

  /// The controller for the player.
  final ApiVideoPlayerController controller;

  /// The style of the player.
  final PlayerStyle? style;

  /// The fit for the video. The overlay is not affected.
  /// See [BoxFit] for more details.
  final BoxFit fit;

  /// The child widget to display as an overlay on top of the video.
  final Widget? child;

  @override
  State<ApiVideoPlayer> createState() => _ApiVideoPlayerState();
}

class _ApiVideoPlayerState extends State<ApiVideoPlayer> {
  final _opacityController = TimedOpacityController();

  @override
  Widget build(BuildContext context) {
    return PlayerVideo(
        controller: widget.controller,
        fit: widget.fit,
        child: widget.child ??
            TimedOpacity(
                controller: _opacityController,
                child: PlayerOverlay(
                    controller: widget.controller,
                    style: widget.style ?? PlayerStyle.defaultStyle,
                    onItemPress: () {
                      _opacityController.showForDuration();
                    })));
  }
}
