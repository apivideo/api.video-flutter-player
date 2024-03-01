import 'package:json_annotation/json_annotation.dart';

part 'apivideo_types.g.dart';

/// The video types enabled by api.video platform.
enum VideoType {
  /// Video on demand.
  @JsonValue("vod")
  vod,

  /// Live video.
  @JsonValue("live")
  live
}

/// The video options that defines a video on api.video platform.
@JsonSerializable()
class VideoOptions {
  /// The video id or live stream id from api.video platform.
  String videoId;

  /// The video type. Either [VideoType.vod] or [VideoType.live].
  VideoType type;

  /// The private token if the video is private.
  String? token;

  /// Creates a [VideoOptions] object from a [videoId] a [type] and a [token].
  /// The [token] could be null.
  VideoOptions.raw({required this.videoId, required this.type, this.token});

  /// Creates a [VideoOptions] object from a [videoId] a [type] and a [token].
  /// If the [type] is null, it will be inferred from the [videoId]:
  ///  * If the [videoId] starts with "vi", the type will be [VideoType.vod].
  ///  * If the [videoId] starts with "li", the type will be [VideoType.live].
  /// The [token] could be null.
  factory VideoOptions(
      {required String videoId, VideoType? type, String? token}) {
    type ??= _inferType(videoId);
    return VideoOptions.raw(videoId: videoId, type: type, token: token);
  }

  /// Creates a [VideoOptions] from a [json] map.
  factory VideoOptions.fromJson(Map<String, dynamic> json) =>
      _$VideoOptionsFromJson(json);

  /// Creates a json map from a [VideoOptions].
  Map<String, dynamic> toJson() => _$VideoOptionsToJson(this);

  /// Infers the [VideoType] from a [videoId].
  /// If the [videoId] starts with "vi", the type will be [VideoType.vod].
  /// If the [videoId] starts with "li", the type will be [VideoType.live].
  static VideoType _inferType(String videoId) {
    if (videoId.startsWith("vi")) {
      return VideoType.vod;
    } else if (videoId.startsWith("li")) {
      return VideoType.live;
    } else {
      throw ArgumentError(
          "Failed to infer the video type from the videoId: $videoId");
    }
  }
}
