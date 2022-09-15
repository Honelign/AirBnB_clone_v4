import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';

part 'podcastSeasons.g.dart';

@JsonSerializable()
class PodCastSeasons {
  final int id;
  final String title;
  final String cover;

  final List<PodCastEpisode> episodes;
  
  final String narrator;

  PodCastSeasons({
    required this.id,
    required this.title,
    required this.cover,
   
    required this.episodes,
    required this.narrator
  });

  factory PodCastSeasons.fromJson(Map<String, dynamic> json) {
    return _$PodCastSeasonsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodCastSeasonsToJson(this);
}
