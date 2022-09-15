import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
part 'artist.g.dart';

@JsonSerializable()
class Artist {
  final int id;
  final String name, cover;
  final List<Music> musics;
  final List<Album>? albums;
  // final List<Music>? popular;

  Artist({
    required this.id,
    required this.name,
    required this.cover,
    required this.musics,
    this.albums,
    // this.popular,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return _$ArtistFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
