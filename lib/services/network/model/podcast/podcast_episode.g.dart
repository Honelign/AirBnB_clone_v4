part of "podcast_episode.dart";

PodcastEpisode _$PodcastEpisodeFromJson(Map<String, dynamic> json) =>
    PodcastEpisode(
      id: json['id'],
      episodeTitle: json['episode_name'],
      cover: json['episode_coverImage'],
      audio: json['episode_audioFile'],
      hostName: json['host_name'],
      hostId: json['host'],
      categoryId: json['category'],
      priceETB: 10.0,
      isPurchasedByUser: true,
    );

Map<String, dynamic> _$PodcastEpisodeToJson(PodcastEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'episode_name': instance.episodeTitle,
      "episode_coverImage": instance.cover,
      'hostName': instance.hostName,
      "hostId": instance.hostId,
      "categoryId": instance.categoryId,
      "audio": instance.audio,
    };
