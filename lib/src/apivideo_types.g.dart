// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apivideo_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoOptions _$VideoOptionsFromJson(Map<String, dynamic> json) => VideoOptions(
      videoId: json['videoId'] as String,
      type: $enumDecodeNullable(_$VideoTypeEnumMap, json['type']) ??
          VideoType.vod,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$VideoOptionsToJson(VideoOptions instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'type': _$VideoTypeEnumMap[instance.type]!,
      'token': instance.token,
    };

const _$VideoTypeEnumMap = {
  VideoType.vod: 'vod',
  VideoType.live: 'live',
};
