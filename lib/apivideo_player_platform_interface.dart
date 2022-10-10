import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apivideo_player_controller.dart';

abstract class ApiVideoPlayerControllerInterface {
  Future<void> play() {
    throw UnimplementedError('play() has not been implemented.');
  }

  Future<void> pause() {
    throw UnimplementedError('pause() has not been implemented.');
  }
}
