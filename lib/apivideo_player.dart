import 'package:apivideo_player/apivideo_player_controller.dart';
import 'package:apivideo_player/apivideo_player_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'apivideo_types.dart';

class ApiVideoPlayer extends StatelessWidget {
  const ApiVideoPlayer(
      {super.key,
      required this.videoId,
      required this.videoType,
      required this.onViewCreated,
      this.privateToken});

  final Function onViewCreated;
  final String videoId;
  final VideoType videoType;
  final String? privateToken;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'plugins.video.api/flutter_player_view';

    if (kIsWeb) {
      return const ApiVideoPlayerWeb();
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
            viewType: viewType,
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams: _buildCreationParams(),
            creationParamsCodec: const StandardMessageCodec());
      case TargetPlatform.iOS:
        return UiKitView(
            viewType: viewType,
            onPlatformViewCreated: _onPlatformViewCreated,
            creationParams: _buildCreationParams(),
            creationParamsCodec: const StandardMessageCodec());
      default:
        return Text(
            '$defaultTargetPlatform is not yet supported by the apivideo_player plugin');
    }
  }

  void _onPlatformViewCreated(int id) =>
      onViewCreated(ApiVideoPlayerController.withId(id));

  Map<String, dynamic> _buildCreationParams() {
    Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams["videoId"] = videoId;
    creationParams["videoType"] = videoType.name;
    creationParams["privateToken"] = privateToken;

    return creationParams;
  }
}
