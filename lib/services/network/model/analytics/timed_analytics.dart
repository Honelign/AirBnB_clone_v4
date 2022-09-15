import 'package:json_annotation/json_annotation.dart';

part 'timed_analytics.g.dart';

@JsonSerializable()
class TimedAnalyticsData {
  final String viewCount;
  final String viewTimeLine;

  TimedAnalyticsData({required this.viewCount, required this.viewTimeLine});

  factory TimedAnalyticsData.fromJson(Map<String, dynamic> json) {
    return _$TimedAnalyticsDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TimedAnalyticsDataToJson(this);
}
