import 'package:json_annotation/json_annotation.dart';
part 'playlist_titles.g.dart';
@JsonSerializable()
class PlayListTitles{
 final int id;
 final String title;

 PlayListTitles({required this.id,required this.title});

 factory PlayListTitles.fromJson(Map<String, dynamic> json) {
   return _$PlayListTitlesFromJson(json);
 }

 Map<String, dynamic> toJson() => _$PlayListTitlesToJson(this);
}