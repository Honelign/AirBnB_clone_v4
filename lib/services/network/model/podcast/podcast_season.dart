import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_info.dart';

part 'podcast_season.g.dart';

@JsonSerializable()
class PodcastSeason {
  final int id;
  final int seasonNumber;
  final int numberOfEpisodes;
  final String cover;

  PodcastSeason(
      {required this.id,
      required this.seasonNumber,
      required this.numberOfEpisodes,
      required this.cover});

  factory PodcastSeason.fromJson(Map<String, dynamic> json) {
    return _$PodcastSeasonFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodcastCategoryToJson(this);
}
