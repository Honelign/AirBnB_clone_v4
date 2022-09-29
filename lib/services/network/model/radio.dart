import 'package:json_annotation/json_annotation.dart';

part 'radio.g.dart';

@JsonSerializable()
class RadioStation {
  int id;
  //@JsonKey(name: 'station_name')
  String stationName;
  String mhz;
  String url;
  String coverImage;
  String stationDescription;
  String? encoder_FUI;
  String? created_at;
  String? updated_at;

  RadioStation({
    required this.id,
    required this.stationName,
    required this.mhz,
    required this.url,
    required this.coverImage,
    required this.stationDescription,
    this.created_at,
    this.encoder_FUI,
    this.updated_at,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return _$RadioFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RadioToJson(this);
}
