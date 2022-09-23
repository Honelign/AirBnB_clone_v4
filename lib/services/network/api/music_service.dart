import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

class MusicApiService {
  // get new tracks
  Future getMusic(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Music> music = item.map((value) => Music.fromJson(value)).toList();

        return music;
      } else {}
    } catch (e) {
      print("@music_service getMusic $e");
    }
    return [];
  }

  // get album tracks
  Future getAlbumMusic(apiEndPoint, String album_id) async {
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint$album_id"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Music> music = item.map((value) => Music.fromJson(value)).toList();

        return music;
      } else {}
    } catch (e) {
      print("@music_service getMusic $e");
    }
    return [];
  }

  // albums
  Future getAlbums(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Album> albums = item.map((value) {
          return Album.fromJson(value);
        }).toList();

        return albums;
      } else {}
    } catch (e) {
      print("@music_service -> getAlbums error - $e");
    }
    return [];
  }

  Future getArtistAlbums(apiEndPoint, artist_id) async {
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint$artist_id"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Album> albums = item.map((value) {
          return Album.fromJson(value);
        }).toList();

        return albums;
      } else {}
    } catch (e) {
      print("@music_service -> getAlbums error - $e");
    }
    return [];
  }

  // get artists
  Future getArtists(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        item.forEach((artist) {
          artist['Albums'].forEach((album) {
            List allAlbums = artist['Tracks']
                .where((track) =>
                    track['album_id'].toString() == album['id'].toString())
                .toList();

            album['Tracks'] = allAlbums;
          });
        });

        List<Artist> artists = item.map((value) {
          return Artist.fromJson(value);
        }).toList();

        return artists;
      }
    } catch (e) {
      print("@music_service -> getArtists error - $e");
    }
    return [];
  }

  // get genres
  Future<List<Genre>> getGenres(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Genre> genres = item.map((value) {
          return Genre.fromJson(value);
        }).toList();
        return genres;
      }
    } catch (e) {
      print("@music_service -> getGenres error $e");
    }
    return [];
  }

  Future addPopularCount(
      {required String track_id, required String user_id}) async {
    var data = {"user_id": user_id, "track_id": track_id};
    Response response = await post(
      Uri.parse("${kAnalyticsBaseUrl}/view_count"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
}
