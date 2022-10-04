import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicApiService {
  // helper class
  HelperUtils helper = HelperUtils();

  // error logging service
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  // get new tracks
  Future getMusic({required String apiEndPoint, required int pageKey}) async {
    List<Music> music = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?userId=$uid&page=$pageKey"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        music = item.map((value) => Music.fromJson(value)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "music_service",
        functionName: "getMusic",
        errorInfo: e.toString(),
      );
    }
    return music;
  }

  // get album tracks
  Future getAlbumMusic(apiEndPoint, String album_id) async {
    List<Music> music = [];
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint$album_id"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        music = item.map((value) => Music.fromJson(value)).toList();

        return music;
      } else {}
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "music_service",
        functionName: "getAlbumMusic",
        errorInfo: e.toString(),
      );
    }
    return music;
  }

  // get artists
  Future getArtists({required String apiEndPoint, int pageSize = 1}) async {
    List<Artist> artists = [];
    try {
      String uid = await helper.getUserId();
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint?page=$pageSize"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        artists = item.map((value) {
          return Artist.fromJson(value);
        }).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "music_service",
        functionName: "getArtists",
        errorInfo: e.toString(),
      );
    }

    return artists;
  }

  // albums
  Future getAlbums({required String apiEndPoint, int pageSize = 1}) async {
    List<Album> albums = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?userId=$uid&page=$pageSize"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        albums = item.map((value) {
          return Album.fromJson(value);
        }).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "music_service",
        functionName: "getAlbums",
        errorInfo: e.toString(),
      );
    }
    return albums;
  }

  Future getArtistAlbums(apiEndPoint, artist_id) async {
    List<Album> album = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(Uri.parse(
          "$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artist_id"));
      print("$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artist_id");
      print("statuscode=" + response.statusCode.toString());

      if (response.statusCode == 200) {
        print("body" + response.body.toString());
        final item = json.decode(response.body) as List;
        print("item type" + item.runtimeType.toString());

        album = item.map((e) {
          return Album(
              artist: e['artist_name'],
              artist_id: e['artist_id'],
              count: e['noOfTracks'],
              cover: e['album_coverImage'],
              description: e['album_description'],
              id: e['id'],
              isPurchasedByUser: e['is_purchasedByUser'],
              price: e['album_price'],
              title: e['album_name']);
        }).toList();
        print("done");
      } else {
        print("error");
      }
    } catch (e) {
      print("album artist error shit" + e.toString());
    }
    return album;
  }

  Future getArtistAlbumsTracks(apiEndPoint, artist_id) async {
    List<Album> album = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(Uri.parse(
          "$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artist_id"));
      print("$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artist_id");
      print("statuscode=" + response.statusCode.toString());

      if (response.statusCode == 200) {
        print("body" + response.body.toString());
        final item = json.decode(response.body) as List;
        print("item type" + item.runtimeType.toString());

        album = item.map((e) {
          return Album(
              artist: e['artist_name'],
              artist_id: e['artist_id'],
              count: e['noOfTracks'],
              cover: e['album_coverImage'],
              description: e['album_description'],
              id: e['id'],
              isPurchasedByUser: e['is_purchasedByUser'],
              price: e['album_price'],
              title: e['album_name']);
        }).toList();
        print("done");
      } else {
        print("error");
      }
    } catch (e) {
      print("album artist error shit" + e.toString());
    }
    return album;
  }

  // ignore: slash_for_doc_comments
  /**
   * ==================================
   * GENRE METHODS
   * ==================================
   */

  // get list of all available genres
  Future<List<Genre>> getGenres(
      {required String apiEndPoint, required int pageKey}) async {
    List<Genre> genres = [];
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint?page=$pageKey"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        genres = item.map((value) {
          return Genre.fromJson(value);
        }).toList();
        return genres;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "music_service",
        functionName: "getGenres",
        errorInfo: e.toString(),
      );
    }
    return genres;
  }

  // get list of all available genres
  Future<List<Music>> getMusicByGenreID({
    required String apiEndPoint,
    required String genreId,
    required int pageKey,
  }) async {
    List<Music> tracksUnderGenre = [];

    try {
      // get user Id
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = prefs.getString("id") ?? "";

      // make api call
      Response response = await get(
        Uri.parse(
          "$kinMusicBaseUrl$apiEndPoint?userId=$uid&genreId=$genreId&page=$pageKey",
        ),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as List;

        tracksUnderGenre = result.map((track) {
          return Music.fromJson(track);
        }).toList();
      }
    } catch (e) {
      print("@music_service -> getMusicByGenreID error $e");
    }

    return tracksUnderGenre;
  }

  Future addPopularCount({required Music music}) async {
    String uid = await helper.getUserId();
    var data = {
      "user_FUI": uid,
      "track_id": music.id,
      "genre_id": music.genreId,
      "album_id": music.albumId,
      "artist_id": music.artist_id,
      "encoder_FUI": music.encoder_id,
    };

    Response response = await post(
      Uri.parse("$kAnalyticsBaseUrl/view_count"),
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
