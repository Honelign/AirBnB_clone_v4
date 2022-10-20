part of "podcast_season.dart";

PodcastSeason _$PodcastSeasonFromJson(Map<String, dynamic> json) =>
    PodcastSeason(
      id: json['id'] as int,
      seasonNumber: json['season_name'],
      cover: json['season_coverImage'],
      numberOfEpisodes: json['numberOfEpisodes'],
    );

Map<String, dynamic> _$PodcastCategoryToJson(PodcastSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seasonNumber': instance.seasonNumber,
      "numberOfEpisodes": instance.numberOfEpisodes,
      'cover': instance.cover,
    };
