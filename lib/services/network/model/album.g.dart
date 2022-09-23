// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Album _$AlbumFromJson(Map<String, dynamic> json) => Album(
      id: json['id'] as int,
      title: json['album_name'] as String,
      cover: json['album_coverImage'] as String,
      description: json['album_description'] as String,
      price: json['album_price'].toString(),
      artist_id: json['artist_id'].toString(),
      artist: json['artist_name'] as String,
      isPurchasedByUser: json['is_purchasedByUser'] ?? false,
      count: 5,
    );
Map<String, dynamic> _$AlbumToJson(Album instance) => <String, dynamic>{
      'id': instance.id,
      'album_name': instance.title,
      'album_coverImage': instance.cover,
      'album_description': instance.description,
      'album_price': instance.price,
      'artist_id': instance.artist_id,
      'artist_name': instance.artist,
      'is_purchasedByUser': instance.isPurchasedByUser,
      'count': instance.count
    };
