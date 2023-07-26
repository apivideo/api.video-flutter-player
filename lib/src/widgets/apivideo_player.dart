import 'package:apivideo_player/src/apivideo_player_controller.dart';
import 'package:apivideo_player/src/style/apivideo_theme.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_opacity.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_overlay.dart';
import 'package:apivideo_player/src/widgets/apivideo_player_video.dart';
import 'package:flutter/material.dart';

/// The main player widget.
/// It displays a [Stack] containing the video and a child widget.
/// The child widget is the player overlay by default.
///
/// To display a custom overlay, use [ApiVideoPlayer] and provide a [child].
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
      this.theme = ApiVideoPlayerTheme.defaultTheme,
      this.child});

  const ApiVideoPlayer.withoutControls(
      {Key? key, required ApiVideoPlayerController controller})
      : this(key: key, controller: controller, child: const SizedBox.shrink());

  /// The controller for the player.
  final ApiVideoPlayerController controller;

  /// The theme for the player.
  final ApiVideoPlayerTheme theme;

  /// The child widget to display as an overlay on top of the video.
  final Widget? child;

  @override
  State<ApiVideoPlayer> createState() => _ApiVideoPlayerState();
}

class _ApiVideoPlayerState extends State<ApiVideoPlayer> {
  final _opacityController = ApiVideoPlayerOpacityController();

  @override
  Widget build(BuildContext context) {
    return ApiVideoPlayerVideo(
        controller: widget.controller,
        child: widget.child ??
            ApiVideoPlayerOpacity(
                controller: _opacityController,
                child: ApiVideoPlayerOverlay(
                    controller: widget.controller,
                    theme: widget.theme,
                    onItemPress: () {
                      _opacityController.showForDuration();
                    })));
  }
}
