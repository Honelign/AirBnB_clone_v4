// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_title.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaylistTitle _$PlaylistTitleFromJson(Map<String, dynamic> json) =>
    PlaylistTitle(
      id: json['playlist_id'] as int,
      title: json['playlist_name'] as String,
      playlists: [],
    );

Map<String, dynamic> _$PlaylistTitleToJson(PlaylistTitle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'playlists': instance.playlists,
    };
