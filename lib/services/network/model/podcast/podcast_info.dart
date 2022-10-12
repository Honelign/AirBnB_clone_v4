part 'podcast_info.g.dart';

class PodcastInfo {
  final int id;
  final String categoryId;
  final String title;
  final String hostName;
  final String hostId;
  final String cover;
  final String description;
  final int numberOfSeasons;
  final int numberOfEpisodes;

  PodcastInfo({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.hostName,
    required this.hostId,
    required this.cover,
    required this.description,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
  });

  factory PodcastInfo.fromJson(Map<String, dynamic> json) {
    return _$PodcastInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodcastInfoToJson(this);
}
