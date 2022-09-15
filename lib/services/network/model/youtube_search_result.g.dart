// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'youtube_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YoutubeSearchResult _$YoutubeSearchResultFromJson(Map<String, dynamic> json) =>
    YoutubeSearchResult(
      id: json['video_id'] as String,
      url: json['video_url'] as String,
      title: json['video_title'] as String,
      cover: json['video_cover'] as String,
      channel: json['video_channel'] as String,
      description: json['video_description'] as String,
    );

Map<String, dynamic> _$YoutubeSearchResultToJson(
        YoutubeSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'title': instance.title,
      'cover': instance.cover,
      'channel': instance.channel,
      'description': instance.description,
    };
