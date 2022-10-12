import 'package:json_annotation/json_annotation.dart';

part 'podcast_episode.g.dart';

@JsonSerializable()
class PodcastEpisode {
  final int id;
  final int hostId;
  final int categoryId;
  final String episodeTitle;
  final String hostName;
  final String audio;
  final String cover;

  PodcastEpisode({
    required this.id,
    required this.episodeTitle,
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
