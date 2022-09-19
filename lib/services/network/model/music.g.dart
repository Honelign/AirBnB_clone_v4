// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Music _$MusicFromJson(Map<String, dynamic> json) => Music(
      id: json['id'] as int,
      title: json['track_name'] as String,
      audio: json['track_file'] as String,
      cover: json['track_cover'] as String ?? 'kinmusic',
      description: json['Genre']['genre_title'] as String ?? 'related result',
      lyrics: json['Lyrics'] as String ?? '',
      artist: json['artist_name'] as String ?? 'kin artist',
      artist_id: json['artist_id'].toString(),
      isPurchasedByUser: false,
      priceETB: json['track_price'].toString(),
      priceUSD: json['track_price'].toString(),
    );

Map<String, dynamic> _$MusicToJson(Music instance) => <String, dynamic>{
      'id': instance.id,
      'track_name': instance.title,
      'track_file': instance.audio,
      'track_cover': instance.cover,
      'artist_name': instance.artist,
      "Genre": {
        'genre_title': instance.description,
      },
      'Lyrics': instance.lyrics,
      'artist_id': instance.artist_id,
      'isPurchasedByUser': instance.isPurchasedByUser,
      "track_price": instance.priceETB,
      "track_price": instance.priceUSD,
    };
