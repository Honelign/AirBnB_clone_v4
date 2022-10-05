import 'package:json_annotation/json_annotation.dart';

part 'album.g.dart';

@JsonSerializable()
class Album {
  final int id, count, price, artist_id;
  final String title, artist, description, cover;
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
