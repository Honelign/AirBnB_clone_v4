import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

part 'playlist_info.g.dart';

@JsonSerializable()
class PlaylistInfo {
  final int id;
  final String name;

  PlaylistInfo({required this.id, required this.name});

  factory PlaylistInfo.fromJson(Map<String, dynamic> json) {
    return _$PlaylistInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlaylistInfoToJson(this);
}
