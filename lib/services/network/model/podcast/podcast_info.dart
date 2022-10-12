part 'podcast_info.g.dart';

class PodcastInfo {
  final int id;
  final int hostId;
  final int categoryId;
  final int numberOfSeasons;
  final int numberOfEpisodes;
  final String title;
  final String hostName;
  final String cover;
  final String description;

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
