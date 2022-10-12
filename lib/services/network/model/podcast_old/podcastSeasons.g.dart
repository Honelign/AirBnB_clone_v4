// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcastSeasons.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PodCastSeasons _$PodCastSeasonsFromJson(Map<String, dynamic> json) => PodCastSeasons(
      id: json['season_id'] as int,
      title: json['season_title'] as String,
      cover: json['season_cover'] as String,
      
      // duration: (json['season_title'] as num).toDouble(),
      
      episodes: (json['Episodes'] as List<dynamic>)
          .map((e) => PodCastEpisode.fromJson(e as Map<String, dynamic>))
          .toList(),
      narrator: json['host_name'] as String,
    );
/*
    {
        "season_id": 1,
        "season_title": "Season 1",
        "season_cover": "Media_Files/Seasons_Cover_Images/Season 1/Season_1_-_podcastCover1.png",
        "host_id": 1,
        "host_name": "Dawit",
        "Episodes": [
            {
                "episode_id": 1,
                "episode_title": "ሃምሳ አለቃ ገብሩ play",
                "episode_file": "Media_Files/Episode_Files/ሃምሳ አለቃ ገብሩ play/ሃምሳ_አለቃ_ገብሩ_play_-_hamsalekahoya.mp3",
                "podcast_category_id": 1,
                "podcast_category_title": "Technology"
            }
        ]
    }

*/
Map<String, dynamic> _$PodCastSeasonsToJson(PodCastSeasons instance) => <String, dynamic>{
      'season_id': instance.id,
      'season_title': instance.title,
      'season_cover': instance.cover,
     
      'Episodes': instance.episodes,
      
      'host_name': instance.narrator,
    };
