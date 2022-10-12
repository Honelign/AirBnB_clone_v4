part of 'podcast_info.dart';

PodcastInfo _$PodcastInfoFromJson(Map<String, dynamic> json) => PodcastInfo(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['podcast_title'],
      hostName: json['podcast_hostName'],
      hostId: json['podcast_hostId'],
      cover: json['podcast_coverImage'],
      description: json['podcast_description'],
      numberOfEpisodes: json['numberOfEpisodes'],
      numberOfSeasons: json['numberOfSeasons'],
    );

Map<String, dynamic> _$PodcastInfoToJson(PodcastInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      "title": instance.title,
      "hostName": instance.hostName,
      "hostId": instance.hostId,
      "cover": instance.cover,
      "description": instance.description,
      "numberOfEpisodes": instance.numberOfEpisodes,
      "numberOfSeasons": instance.numberOfSeasons,
    };
