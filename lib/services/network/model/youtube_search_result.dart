import 'package:json_annotation/json_annotation.dart';

part 'youtube_search_result.g.dart';

@JsonSerializable()
class YoutubeSearchResult {
  final String id;
  final String url;
  final String title;
  final String cover;
  final String channel;
  final String description;

  YoutubeSearchResult(
      {required this.id,
      required this.url,
      required this.title,
      required this.cover,
      required this.channel,
      required this.description});

  factory YoutubeSearchResult.fromJson(Map<String, dynamic> json) {
    return _$YoutubeSearchResultFromJson(json);
  }

  Map<String, dynamic> toJson() => _$YoutubeSearchResultToJson(this);
}
