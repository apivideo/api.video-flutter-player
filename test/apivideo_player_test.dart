// import 'package:flutter_test/flutter_test.dart';
// import 'package:apivideo_player/apivideo_player.dart';
// import 'package:apivideo_player/apivideo_player_platform_interface.dart';
// import 'package:apivideo_player/apivideo_player_controller.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockApiVideoPlayerPlatform
//     with MockPlatformInterfaceMixin
//     implements ApiVideoPlayerPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final ApiVideoPlayerPlatform initialPlatform = ApiVideoPlayerPlatform.instance;

//   test('$ApiVideoPlayerController is the default instance', () {
//     expect(initialPlatform, isInstanceOf<ApiVideoPlayerController>());
//   });

//   test('getPlatformVersion', () async {
//     ApiVideoPlayer apivideoPlayerPlugin = ApiVideoPlayer();
//     MockApiVideoPlayerPlatform fakePlatform = MockApiVideoPlayerPlatform();
//     ApiVideoPlayerPlatform.instance = fakePlatform;
  
//     expect(await apivideoPlayerPlugin.getPlatformVersion(), '42');
//   });
// }
