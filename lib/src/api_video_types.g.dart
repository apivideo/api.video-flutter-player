// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_video_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoOptions _$VideoOptionsFromJson(Map<String, dynamic> json) => VideoOptions(
      videoId: json['videoId'] as String,
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['videoType']) ??
          VideoType.vod,
    );

Map<String, dynamic> _$VideoOptionsToJson(VideoOptions instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'videoType': _$VideoTypeEnumMap[instance.videoType]!,
    };

const _$VideoTypeEnumMap = {
  VideoType.vod: 'vod',
  VideoType.live: 'live',
};
