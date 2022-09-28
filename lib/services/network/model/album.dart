import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
part 'album.g.dart';

@JsonSerializable()
class Album {
  final int id, count,price, artist_id;
  final String title, artist, description, cover;
  final bool isPurchasedByUser;

  Album(
      {required this.id,
      required this.count,
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
