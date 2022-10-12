part of "podcast_season.dart";

PodcastSeason _$PodcastSeasonFromJson(Map<String, dynamic> json) =>
    PodcastSeason(
      id: json['id'] as int,
      seasonNumber: json['seasonNumber'],
      numberOfEpisodes: json['numberOfEpisodes'],
      cover: json['podcast_coverImage'],
    );

Map<String, dynamic> _$PodcastCategoryToJson(PodcastSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonNumber': instance.seasonNumber,
      'cover': instance.cover,
    };
