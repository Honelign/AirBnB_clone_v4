// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCast _$PodCastFromJson(Map<String, dynamic> json) => PodCast(
      id: json['season_id'] as int,
      title: json['season_title'] as String,
      cover: json['season_cover'] as String,
      description: 'Powered By Kin Music',
      // duration: (json['season_title'] as num).toDouble(),
      duration: "69",
      episodes: (json['Episodes'] as List<dynamic>)
          .map((e) => PodCastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
      narrator: json['host_name'] as String,
    );

Map<String, dynamic> _$PodCastToJson(PodCast instance) => <String, dynamic>{
      'season_id': instance.id,
      'season_title': instance.title,
      'season_cover': instance.cover,
      'description': instance.description,
      'Episodes': instance.episodes,
      'season_title': instance.duration,
      'host_name': instance.narrator,
    };
