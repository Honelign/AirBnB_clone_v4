import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/analytics/music_info.dart';

part 'album_info.g.dart';

@JsonSerializable()
class AlbumInfo {
  final String id;
  final String name;
  final String image;
  final List musics;

  AlbumInfo({
    required this.id,
    required this.name,
    required this.image,
    required this.musics,
  });

  factory AlbumInfo.fromJson(Map<String, dynamic> json) {
    return _$ArtistInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AlbumInfoToJson(this);
}
