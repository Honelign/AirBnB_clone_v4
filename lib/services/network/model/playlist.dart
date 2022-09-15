import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

part 'playlist.g.dart';

@JsonSerializable()
class PlayList {
  final int? id;
  final Music? music;

  PlayList({this.id, this.music});

  factory PlayList.fromJson(Map<String, dynamic> json) {
    return _$PlayListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlayListToJson(this);
}
