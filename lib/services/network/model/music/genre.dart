import 'package:json_annotation/json_annotation.dart';

part 'genre.g.dart';

@JsonSerializable()
class Genre {
  final int id;
  final String title;
  final String cover;

  Genre({required this.id, required this.title, required this.cover});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return _$GenreFromJson(json);
  }

  Map<String, dynamic> toJson() => _$GenreToJson(this);
}
