// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArtistInfo _$ArtistInfoFromJson(Map<String, dynamic> json) => ArtistInfo(
      id: json['id'].toString(),
      name: json['artist_name'],
      image: json['artist_profileImage'],
    );

Map<String, dynamic> _$ArtistInfoToJson(ArtistInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artist_name': instance.name,
      'artist_profileImage': instance.image,
    };
