import 'package:json_annotation/json_annotation.dart';

part 'artist.g.dart';

@JsonSerializable()
class Artist {
  final int id;
  final String artist_name, artist_profileImage;
  final int noOfAlbums, noOfTracks;

  Artist({
    // this.popular,
    required this.id,
    required this.artist_profileImage,
    required this.noOfTracks,
    required this.artist_name,
    required this.noOfAlbums,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return _$ArtistFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
