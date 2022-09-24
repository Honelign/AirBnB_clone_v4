import 'package:json_annotation/json_annotation.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

part 'artist.g.dart';

@JsonSerializable()
class Artist {
  final int id;
  final String artist_name, artist_profileImage;
  final int noOfAlbums, noOfTracks;

  // final List<Music>? popular;
  /* "id": 5,
        "artist_name": "aewfsdc",
        "artist_profileImage": "Media_Files/Artists_Profile_Images/aewfsdc_kid.jpg",
        "noOfAlbums": 0,
        "noOfTracks": 0 */

  Artist({
    // this.popular,
    required this.id,
    required this.artist_profileImage,
    required this.noOfTracks,
    required this.artist_name, required this.noOfAlbums,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return _$ArtistFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ArtistToJson(this);
}
