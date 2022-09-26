import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
part 'album.g.dart';

@JsonSerializable()
class Album {
  final int id, count;
  final String title, artist, description, cover, price, artist_id;
  final bool isPurchasedByUser;

  Album(
      {required this.id,
      this.count = 0,
      required this.title,
      required this.artist,
      required this.description,
      required this.cover,
      required this.artist_id,
      required this.price,
      required this.isPurchasedByUser});

  factory Album.fromJson(Map<String, dynamic> json) {
    return _$AlbumFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
