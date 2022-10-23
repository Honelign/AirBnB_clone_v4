part of 'podcast_info.dart';

PodcastInfo _$PodcastInfoFromJson(Map<String, dynamic> json) => PodcastInfo(
      id: json['id'],
      categoryId: json['category'],
      title: json['podcast_name'],
      hostName: json['host_name'],
      hostId: json['host'],
      cover: json['podcast_coverImage'],
      description: json['podcast_description'],
      numberOfEpisodes: json['numberOfSeasons'],
      numberOfSeasons: json['numberOfEpisodes'],
    );

Map<String, dynamic> _$PodcastInfoToJson(PodcastInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.categoryId,
      "podcast_name": instance.title,
      "hostName": instance.hostName,
      "host": instance.hostId,
      "podcast_coverImage": instance.cover,
      "podcast_description": instance.description,
      "numberOfEpisodes": instance.numberOfEpisodes,
      "numberOfSeasons": instance.numberOfSeasons,
    };
