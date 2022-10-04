import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

part 'favorite.g.dart';

@JsonSerializable()
class Favorite {
  final String id;
  final Music music;

  Favorite({required this.id, required this.music});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return _$FavoriteFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}
