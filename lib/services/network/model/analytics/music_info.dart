import 'package:json_annotation/json_annotation.dart';

part 'music_info.g.dart';

@JsonSerializable()
class MusicInfo {
  final String id;
  final String name;
  final String image;

  MusicInfo({
    required this.id,
    required this.name,
    required this.image,
  });

  factory MusicInfo.fromJson(Map<String, dynamic> json) {
    return _$MusicInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MusicInfoToJson(this);
}
