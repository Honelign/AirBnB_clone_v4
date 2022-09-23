// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
    id: json['id'] as int,
    title: json['album_title'] as String,
    cover: json['album_cover'] as String,
    artist: json['artist_name'] as String,
    description: json['album_title'] as String,
    count: json['count'] as int);
Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'album_id': instance.id,
      'album_title': instance.title,
      'artist_name': instance.artist,
      'album_cover': instance.cover,
      'count': instance.count
    };
