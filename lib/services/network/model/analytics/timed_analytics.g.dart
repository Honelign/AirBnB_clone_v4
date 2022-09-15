// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timed_analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimedAnalyticsData _$TimedAnalyticsDataFromJson(Map<String, dynamic> json) =>
    TimedAnalyticsData(
      viewCount: json['total_count'].toString(),
      viewTimeLine: json['date'] ?? json['week'] ?? json['month'] ?? "date",
    );

Map<String, dynamic> _$TimedAnalyticsDataToJson(TimedAnalyticsData instance) =>
    <String, dynamic>{
      'view_count': instance.viewCount,
      'view_timeline': instance.viewTimeLine,
    };
