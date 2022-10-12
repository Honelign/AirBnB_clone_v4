part of "podcast_episode.dart";

PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) =>
    PodcastEpisode(
      id: json['id'],
      episodeTitle: json['episode_number'],
      hostName: json['hostName'],
      hostId: json['hostId'],
      categoryId: json['categoryId'],
      audio: json['audio'],
      cover: json['cover'],
    );

Map<String, dynamic> _$PodcastEpisodeToJson(PodcastEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episodeTitle': instance.episodeTitle,
      'hostName': instance.hostName,
      "hostId": instance.hostId,
      "categoryId": instance.categoryId,
      "audio": instance.audio,
      "cover": instance.cover
    };
