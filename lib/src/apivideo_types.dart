import 'package:json_annotation/json_annotation.dart';

part 'apivideo_types.g.dart';

enum VideoType {
  @JsonValue("vod")
  vod,
  @JsonValue("live")
  live
}

@JsonSerializable()
class VideoOptions {
  String videoId;
  VideoType videoType;

  VideoOptions({required this.videoId, this.videoType = VideoType.vod});
}
