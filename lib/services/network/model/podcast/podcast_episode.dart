import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_info.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';

part 'podcast_episode.g.dart';

@JsonSerializable()
class PodcastEpisode {
  final int id;
  final int episodeNumber;
  final String hostName;
  final int hostId;
  final int categoryId;
  final String audio;
  final String cover;

  PodcastEpisode({
    required this.id,
    required this.episodeNumber,
    required this.hostName,
    required this.hostId,
    required this.categoryId,
    required this.audio,
    required this.cover,
  });

  factory PodcastEpisode.fromJson(Map<String, dynamic> json) {
    return _$PodcastEpisodeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodcastEpisodeToJson(this);
}
