import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';

part 'podcast_category.g.dart';

@JsonSerializable()
class PodCastCategory {
  final int id;
  final String? description;
  final String title;
  final List<PodCastEpisode> podcasts;
  PodCastCategory(
      {required this.id,
      required this.title,
      this.description,
      required this.podcasts});

  factory PodCastCategory.fromJson(Map<String, dynamic> json) {
    return _$PodCastCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodCastCategoryToJson(this);
}
