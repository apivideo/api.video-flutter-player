import 'dart:async';

import 'package:api_video_player/api_video_player.dart';
import 'package:api_video_player/src/api_video_player_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('plugin initialized', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final FakeApiVideoPlayerPlatform fakeVideoPlayerPlatform =
        FakeApiVideoPlayerPlatform();
    ApiVideoPlayerPlatform.instance = fakeVideoPlayerPlatform;

    final ApiVideoPlayerController controller =
        ApiVideoPlayerController(videoOptions: VideoOptions(videoId: "test"));
    await controller.initialize();
    expect(fakeVideoPlayerPlatform.calls.first, 'initialize');
    expect(fakeVideoPlayerPlatform.calls[1], 'create');
  });
}

class FakeApiVideoPlayerPlatform extends ApiVideoPlayerPlatform {
  Completer<bool> initialized = Completer<bool>();
  List<String> calls = <String>[];

  @override
  Future<int?> initialize(bool autoplay) {
    calls.add('initialize');
    initialized.complete(true);
    return Future.value(0);
  }

  @override
  Future<void> create(int textureId, VideoOptions videoOptions) {
    calls.add('create');
    return Future.value();
  }

  @override
  Stream<PlayerEvent> playerEventsFor(int textureId) {
    return StreamController<PlayerEvent>().stream;
  }
}
