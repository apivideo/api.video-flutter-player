import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:apivideo_player/apivideo_player_method_channel.dart';

void main() {
  MethodChannelApiVideoPlayer platform = MethodChannelApiVideoPlayer();
  const MethodChannel channel = MethodChannel('apivideo_player');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
