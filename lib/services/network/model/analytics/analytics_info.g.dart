// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsInfo _$AnalyticsInfoFromJson(Map<String, dynamic> json) =>
    AnalyticsInfo(
      id: json['id'].toString(),
      name: json['album_name'] ?? json['artist_name'] ?? ['track_name'],
      image: json['album_coverImage'] ??
          json['artist_coverImage'] ??
          json['track_coverImage'],
    );

Map<String, dynamic> _$AnalyticsInfoToJson(AnalyticsInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'album_name': instance.name,
      'album_coverImage': instance.image,
    };
