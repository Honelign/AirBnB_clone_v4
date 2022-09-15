
import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/playlist.dart';

part 'playlist_title.g.dart';
@JsonSerializable()
class PlaylistTitle {
  final int id;
  final String title;
  List<PlayList> playlists;

  PlaylistTitle({required this.id, required this.title, required this.playlists});


  factory PlaylistTitle.fromJson(Map<String, dynamic> json) {
    return _$PlaylistTitleFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlaylistTitleToJson(this);
}
