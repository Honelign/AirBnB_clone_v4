import 'package:json_annotation/json_annotation.dart';

part 'music.g.dart';

@JsonSerializable()
class Music {
  final int id;
  final String title;
  @JsonKey(name: 'music_description')
  final String description;
  final String cover;
  final String audio;
  final String? lyrics;
  final String priceETB;
  final String artist_id;
  final String albumId;
  final String genreId;
  final String artist;
  final bool isPurchasedByUser;

  final int? trackIdInPlaylist;

  Music({
    required this.id,
    required this.cover,
    required this.artist,
    required this.title,
    required this.description,
    required this.audio,
    required this.artist_id,
    required this.isPurchasedByUser,
    required this.priceETB,
    required this.albumId,
    required this.genreId,
    this.lyrics,
    this.trackIdInPlaylist,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return _$MusicFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}
