import 'package:apivideo_player/apivideo_player.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Assert no inference when type is explicit', () {
    final videoOptions =
        VideoOptions(videoId: "vi77Dgk0F8eLwaFOtC5870yn", type: VideoType.live);
    expect(videoOptions.videoId, "vi77Dgk0F8eLwaFOtC5870yn");
    expect(videoOptions.type, VideoType.live);
    expect(videoOptions.token, null);
  });

  test('Assert inferred type for vod', () {
    final videoOptions = VideoOptions(videoId: "vi77Dgk0F8eLwaFOtC5870yn");
    expect(videoOptions.videoId, "vi77Dgk0F8eLwaFOtC5870yn");
    expect(videoOptions.type, VideoType.vod);
    expect(videoOptions.token, null);
  });

  test('Assert inferred type for live', () {
    final videoOptions = VideoOptions(videoId: "li77Dgk0F8eLwaFOtC5870yn");
    expect(videoOptions.videoId, "li77Dgk0F8eLwaFOtC5870yn");
    expect(videoOptions.type, VideoType.live);
    expect(videoOptions.token, null);
  });
}
