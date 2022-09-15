import 'package:json_annotation/json_annotation.dart';

part 'music.g.dart';

@JsonSerializable()
class Music {
  final int id;
  @JsonKey(name: 'music_description')
  final String description;
  final String title;
  final String cover;
  final String artist;
  final String audio;
  final bool isPurchasedByUser;
  final String priceETB;
  final String priceUSD;
  final String? lyrics;
  final String artist_id;

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
    required this.priceUSD,
    this.lyrics,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return _$MusicFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MusicToJson(this);
}
