import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/analytics/album_info.dart';

part 'artist_info.g.dart';

@JsonSerializable()
class ArtistInfo {
  final String id;
  final String name;
  final String image;
  final List albums;

  ArtistInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.albums,
  });

  factory ArtistInfo.fromJson(Map<String, dynamic> json) {
    return _$ArtistInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArtistInfoToJson(this);
}
