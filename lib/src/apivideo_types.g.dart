// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apivideo_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoOptions _$VideoOptionsFromJson(Map<String, dynamic> json) => VideoOptions(
      videoId: json['videoId'] as String,
      videoType: $enumDecodeNullable(_$VideoTypeEnumMap, json['videoType']) ??
          VideoType.vod,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$VideoOptionsToJson(VideoOptions instance) =>
    <String, dynamic>{
      'videoId': instance.videoId,
      'videoType': _$VideoTypeEnumMap[instance.videoType]!,
      'token': instance.token,
    };

const _$VideoTypeEnumMap = {
  VideoType.vod: 'vod',
  VideoType.live: 'live',
};
