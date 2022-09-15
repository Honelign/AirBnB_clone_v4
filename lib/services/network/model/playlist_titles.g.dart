// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_titles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayListTitles _$PlayListTitlesFromJson(Map<String, dynamic> json) =>
    PlayListTitles(
      id: json['playlist_id'] as int,
      title: json['playlist_name'] as String,
    );

Map<String, dynamic> _$PlayListTitlesToJson(PlayListTitles instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
