import 'package:flutter/cupertino.dart';

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
  late int _textureId;

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
  }

  @override
  Widget build(BuildContext context) {
    return _textureId == ApiVideoPlayerController.kUninitializedTextureId
        ? Container()
        : _playerPlatform.buildView(_textureId);
  }
}
