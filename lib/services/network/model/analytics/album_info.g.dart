// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumInfo _$ArtistInfoFromJson(Map<String, dynamic> json) => AlbumInfo(
      id: json['id'].toString(),
      name: json['album_name'],
      image: json['album_coverImage'],
    );

Map<String, dynamic> _$AlbumInfoToJson(AlbumInfo instance) => <String, dynamic>{
      'id': instance.id,
      'album_name': instance.name,
      'album_coverImage': instance.image,
    };
