
import 'apivideo_player_platform_interface.dart';

class ApiVideoPlayer {
  Future<String?> getPlatformVersion() {
    return ApiVideoPlayerPlatform.instance.getPlatformVersion();
  }
}
