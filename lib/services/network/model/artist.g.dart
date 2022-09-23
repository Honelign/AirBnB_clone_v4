// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['id'] as int,
      name: json['artist_name'] as String,
      cover: json['artist_cover'] as String,
    );

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'artist_id': instance.id,
      'artist_name': instance.name,
      'artist_cover': instance.cover,
    };
