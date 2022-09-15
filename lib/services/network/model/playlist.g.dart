// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayList _$PlayListFromJson(Map<String, dynamic> json) => PlayList(
      id: json['playlist_id'] as int?,
      music: json['playlist_music'] == null
          ? null
          : Music.fromJson(json['playlist_music'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayListToJson(PlayList instance) => <String, dynamic>{
      'id': instance.id,
      'music': instance.music,
    };
