// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Genre _$GenreFromJson(Map<String, dynamic> json) => Genre(
      id: json['id'] as int,
      title: json['genre_title'] as String,
      cover: json['genre_cover'] as String,
      musics: (json['Tracks'] as List<dynamic>)
          .map((e) => Music.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenreToJson(Genre instance) => <String, dynamic>{
      'genre_id': instance.id,
      'genre_title': instance.title,
      'genre_cover': instance.cover,
      'Tracks': instance.musics,
    };