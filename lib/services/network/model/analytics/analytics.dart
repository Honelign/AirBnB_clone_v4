import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/analytics/timed_analytics.dart';

part 'analytics.g.dart';

@JsonSerializable()
class AnalyticsData {
  final String user_id;
  final String total_count;
  final String total_revenue;
  final List total_daily;
  final List total_weekly;
  final List total_monthly;

  AnalyticsData({
    required this.user_id,
    required this.total_count,
    required this.total_revenue,
    required this.total_daily,
    required this.total_weekly,
    required this.total_monthly,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return _$AnalyticsDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AnalyticsDataToJson(this);
}
