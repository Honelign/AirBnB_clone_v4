part of "podcast_season.dart";

PodcastSeason _$PodcastSeasonFromJson(Map<String, dynamic> json) =>
    PodcastSeason(
      id: json['id'] as int,
      seasonNumber: json['season_name'].toString(),
      cover: json['season_coverImage'].toString(),
      numberOfEpisodes: json['numberOfEpisodes'],
    );

Map<String, dynamic> _$PodcastCategoryToJson(PodcastSeason instance) =>
    <String, dynamic>{
      'id': instance.id,
      'season_name': instance.seasonNumber,
      "numberOfEpisodes": instance.numberOfEpisodes,
      'season_coverImage': instance.cover,
    };
