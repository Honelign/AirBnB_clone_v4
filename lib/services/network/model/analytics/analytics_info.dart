import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/analytics/music_info.dart';

part 'analytics_info.g.dart';

@JsonSerializable()
class AnalyticsInfo {
  final String id;
  final String name;
  final String image;

  AnalyticsInfo({
    required this.id,
    required this.name,
    required this.image,
  });

  factory AnalyticsInfo.fromJson(Map<String, dynamic> json) {
    return _$AnalyticsInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnalyticsInfoToJson(this);
}
