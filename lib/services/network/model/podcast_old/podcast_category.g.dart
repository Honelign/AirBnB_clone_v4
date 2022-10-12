// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCastCategory _$PodCastCategoryFromJson(Map<String, dynamic> json) =>
    PodCastCategory(
      id: json['category_id'] as int,
      title: json['podcast_category_title'] as String,
      description: json['host_name'] as String?,
      podcasts: (json['Episodes'] as List<dynamic>)
          .map((e) => PodCastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
/*
 "host_id": 1,
        "host_name": "Dawit",
        "host_cover": "Media_Files/Hosts_Profile_Images/Dawit/Dawit_-_podcastCover1.png",
        "Seasons": [
            {
                "season_id": 1,
                "season_title": "Season 1",
                "season_cover": "Media_Files/Seasons_Cover_Images/Season 1/Season_1_-_podcastCover1.png",
                "Episodes": [
                    {
                        "episode_id": 1,
                        "episode_title": 
*/
Map<String, dynamic> _$PodCastCategoryToJson(PodCastCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'podcasts': instance.podcasts,
    };
