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

  /// Creates a [VideoOptions] from a [json] map.
  factory VideoOptions.fromJson(Map<String, dynamic> json) =>
      _$VideoOptionsFromJson(json);

  /// Creates a json map from a [VideoOptions].
  Map<String, dynamic> toJson() => _$VideoOptionsToJson(this);
}
