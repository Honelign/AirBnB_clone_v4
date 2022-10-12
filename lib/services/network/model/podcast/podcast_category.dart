import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_info.dart';

part 'podcast_category.g.dart';

@JsonSerializable()
class PodcastCategory {
  final int id;
  final String name;
  final List<PodcastInfo> podcasts;

  PodcastCategory(
      {required this.id, required this.name, required this.podcasts});

  factory PodcastCategory.fromJson(Map<String, dynamic> json) {
    return _$PodcastCategoryFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PodcastCategoryToJson(this);
}
