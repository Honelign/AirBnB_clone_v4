// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artist _$ArtistFromJson(Map<String, dynamic> json) => Artist(
      id: json['id'] as int,
      artist_name: json['artist_name'] as String,
      artist_profileImage: json['artist_profileImage'] as String,
      noOfAlbums: json['noOfAlbums'] as int,
      noOfTracks: json['noOfTracks'] as int,
    );
    /* "id": 5,
        "artist_name": "aewfsdc",
        "artist_profileImage": "Media_Files/Artists_Profile_Images/aewfsdc_kid.jpg",
        "noOfAlbums": 0,
        "noOfTracks": 0 */

Map<String, dynamic> _$ArtistToJson(Artist instance) => <String, dynamic>{
      'id': instance.id,
      'artist_name': instance.artist_name,
      'artist_profileImage': instance.artist_profileImage,
      'noOfAlbums': instance.noOfAlbums,
      'noOfTracks': instance.noOfTracks,
    };
