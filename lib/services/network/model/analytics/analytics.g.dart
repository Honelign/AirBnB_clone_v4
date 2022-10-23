// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticsData _$AnalyticsDataFromJson(Map<String, dynamic> json) =>
    AnalyticsData(
      user_id: json['user_id'].toString(),
      total_count: json['total_count'].toStringAsFixed(0),
      total_revenue: double.parse(json['total_revenue']).toStringAsFixed(1),
      total_daily: (List.from(json['total_weekly']).reversed)
          .map((e) => TimedAnalyticsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_weekly: (List.from(json['total_monthly']).reversed)
          .map((e) => TimedAnalyticsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total_monthly: (List.from(json['total_yearly']).reversed)
          .map((e) => TimedAnalyticsData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalyticsDataToJson(AnalyticsData instance) =>
    <String, dynamic>{
      'total_count': instance.total_count,
      'total_revenue': instance.total_revenue,
      'total_daily': instance.total_daily,
      "total_weekly": instance.total_daily,
      'total_yearly': instance.total_monthly,
    };
