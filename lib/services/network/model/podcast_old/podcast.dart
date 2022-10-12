import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcastEpisode.dart';

part 'podcast.g.dart';

@JsonSerializable()
class PodCast {
  final int id;
  final String title;
  final String cover;
  final String? description;
  final List<PodCastEpisode> episodes;
  final String duration;
  final String narrator;

  PodCast(
      {required this.id,
      required this.title,
      required this.cover,
      required this.description,
      required this.duration,
      required this.episodes,
      required this.narrator});

  factory PodCast.fromJson(Map<String, dynamic> json) {
    return _$PodCastFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodCastToJson(this);
}
