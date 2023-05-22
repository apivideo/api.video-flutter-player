import 'package:json_annotation/json_annotation.dart';

part 'apivideo_types.g.dart';

/// The video types enabled by the api.video API
enum VideoType {
  @JsonValue("vod")
  vod,
  @JsonValue("live")
  live
}

/// The video options that defines an api.video video
@JsonSerializable()
class VideoOptions {
  String videoId;
  VideoType videoType;
  String? token;

  VideoOptions(
      {required this.videoId, this.videoType = VideoType.vod, this.token});

  /// Creates a [VideoOptions] from a [json] map.
  factory VideoOptions.fromJson(Map<String, dynamic> json) =>
      _$VideoOptionsFromJson(json);

  /// Creates a json map from a [VideoOptions].
  Map<String, dynamic> toJson() => _$VideoOptionsToJson(this);
}
