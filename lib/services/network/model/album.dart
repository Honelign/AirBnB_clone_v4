import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
part 'album.g.dart';

@JsonSerializable()
class Album {
  final int id;
  final String title, artist, description, cover;
  final List<Music> musics;

  Album(
      {required this.id,
      required this.title,
      required this.artist,
      required this.description,
      required this.cover,
      // ignore: non_constant_identifier_names
       required this.musics
      });

  factory Album.fromJson(Map<String, dynamic> json) {
    return _$AlbumFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}