// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumInfo _$ArtistInfoFromJson(Map<String, dynamic> json) => AlbumInfo(
      id: json['id'].toString(),
      name: json['album_title'],
      image: json['album_cover'],
      musics: (json['Tracks'] as List<dynamic>)
          .map((e) => MusicInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlbumInfoToJson(AlbumInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      "musics": instance.musics,
    };
