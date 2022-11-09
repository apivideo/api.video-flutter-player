import 'package:apivideo_player/src/apivideo_player_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import 'apivideo_player_controller.dart';
import 'apivideo_player_platform_interface.dart';

ApiVideoPlayerPlatform get _playerPlatform {
  return ApiVideoPlayerPlatform.instance;
}

class ApiVideoPlayer extends StatefulWidget {
  const ApiVideoPlayer({super.key, required this.controller});

  final ApiVideoPlayerController controller;

  @override
  State<ApiVideoPlayer> createState() => _ApiVideoPlayerState();
}

class _ApiVideoPlayerState extends State<ApiVideoPlayer> {
  _ApiVideoPlayerState() {
    _listener = ApiVideoPlayerWidgetListener(onTextureReady: () {
      final int newTextureId = widget.controller.textureId;
      if (newTextureId != _textureId) {
        setState(() {
          _textureId = newTextureId;
        });
      }
    });
  }

  late ApiVideoPlayerWidgetListener _listener;
  late int _textureId;

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    widget.controller.addWidgetListener(_listener);
  }

  @override
  void dispose() {
    widget.controller.removeWidgetListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _textureId == ApiVideoPlayerController.kUninitializedTextureId
        ? Container()
        : buildVideo();
  }

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(),
          Positioned.fill(
              child: ApiVideoPlayerOverlay(controller: widget.controller)),
        ],
      );

  Widget buildVideoPlayer() => SizedBox(
        width: 400.0,
        height: 300.0,
        child: _playerPlatform.buildView(_textureId),
      );
}
