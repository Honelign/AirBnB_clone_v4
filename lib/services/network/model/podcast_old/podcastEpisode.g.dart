// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcastEpisode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
/*{
    "Episode_1": {
        "episode_id": 1,
        "episode_title": "ሃምሳ አለቃ ገብሩ play",
        "episode_file": "Media_Files/Episode_Files/ሃምሳ አለቃ ገብሩ play/ሃምሳ_አለቃ_ገብሩ_play_-_hamsalekahoya.mp3",
        "host_id": 2,
        "host_name": "ሃምሳ አለቃ ገብሩ",
        "season_id": 1,
        "season_title": "Season 1",
        "season_cover": "Media_Files/Seasons_Cover_Images/Season 1/Season_1_-_podcastCover1.png",
        "podcast_category_id": 1,
        "podcast_category_title": "Technology"
    }*/
PodCastEpisode _$PodCastEpisodeFromJson(Map<String, dynamic> json) =>
    PodCastEpisode(
      id: json['episode_id'] as int,
      title: json['episode_title'] as String,
      duration: "69",
      audio: json['episode_file'] as String,
    );
/*

 "Episodes": [
            {
                "episode_id": 1,
                "episode_title": "ሃምሳ አለቃ ገብሩ play",
                "episode_file": "Media_Files/Episode_Files/ሃምሳ አለቃ ገብሩ play/ሃምሳ_አለቃ_ገብሩ_play_-_hamsalekahoya.mp3",
                "podcast_category_id": 1,
                "podcast_category_title": "Technology"
            }
        ]
*/
Map<String, dynamic> _$PodCastEpisodeToJson(PodCastEpisode instance) =>
    <String, dynamic>{
      'episode_id': instance.id,
      'episode_title': instance.title,
      'episode_title': instance.duration,
      'episode_file': instance.audio,
    };
