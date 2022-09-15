// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistInfo _$ArtistInfoFromJson(Map<String, dynamic> json) => ArtistInfo(
      id: json['id'].toString(),
      name: json['artist_name'],
      image: json['artist_cover'],
      albums: (json['Albums'] as List<dynamic>)
          .map((e) => AlbumInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtistInfoToJson(ArtistInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      "albums": instance.albums,
    };
