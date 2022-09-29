// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RadioStation _$RadioFromJson(Map<String, dynamic> json) => RadioStation(
    id: json['id'] as int,
    stationName: json['station_name'] as String,
    mhz: (json['station_frequency'].toString()) as String,
    url: json['station_url'] as String,
    coverImage: json['station_cover'] as String,
    stationDescription: json['station_description'] as String,
    created_at: json['created_at'] ?? " ",
    encoder_FUI: json['encoder_FUI'] ?? " ",
    updated_at: json["updated_at"] ?? " ");
/*

        "id": 1,
        "station_name": "dani",
        "station_frequency": 76.0,
        "station_url": "test",
        "station_cover": "https://storage.googleapis.com/kin-project-352614-storage/Media_Files/Station_Cover_Images/dani/dani_-_Kin_Logo_final.png",
        "station_description": "test",
        "user_id": 1,
        "created_at": "2022-08-08T12:25:59.675072Z",
        "updated_at": "2022-08-08T12:25:59.675105Z"
*/
Map<String, dynamic> _$RadioToJson(RadioStation instance) => <String, dynamic>{
      'id': instance.id,
      'station_name': instance.stationName,
      'station_frequency': instance.mhz,
      'station_url': instance.url,
      'station_cover': instance.coverImage,
    };
