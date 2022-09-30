// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Music _$MusicFromJson(Map<String, dynamic> json) => Music(
      id: json['id'] as int,
      title: json['track_name'] as String,
      description: json['track_description'] as String ?? 'related result',
      cover: json['track_coverImage'] as String ?? 'kinmusic',
      audio: json['track_audioFile'] as String,
      lyrics: json['track_lyrics'] as String ?? '',
      priceETB: json['track_price'].toString(),
      artist_id: json['artist_id'].toString(),
      albumId: json['album_id'].toString(),
      genreId: json['genre_id'].toString(),
      artist: json['artist_name'] as String ?? 'kin artist',
      isPurchasedByUser: json['is_purchasedByUser'] ?? false,
      trackIdInPlaylist: json['playlist_track_id'] ?? -1,
    );

Map<String, dynamic> _$MusicToJson(Music instance) => <String, dynamic>{
      'id': instance.id,
      'track_name': instance.title,
      "track_description": instance.description,
      'track_coverImage': instance.cover,
      'track_audioFile': instance.audio,
      "track_price": instance.priceETB,
      'artist_id': instance.artist_id,
      "albumId": instance.albumId,
      'genre_id': instance.genreId,
      'artist_name': instance.artist,
      'track_lyrics': instance.lyrics,
      'is_purchasedByUser': instance.isPurchasedByUser,
      'trackIdInPlaylist': instance.trackIdInPlaylist,
    };
