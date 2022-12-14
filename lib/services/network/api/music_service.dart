import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';
import 'package:kin_music_player_app/services/network/model/music/genre.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicApiService {
  // const
  String fileName = "music_service.dart";
  String className = "MusicApiService";

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
        fileName: fileName,
        functionName: "getMusic",
        errorInfo: e.toString(),
        className: className,
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
        fileName: fileName,
        functionName: "getAlbumMusic",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return music;
  }

  // get artists
  Future getArtists({required String apiEndPoint, int pageSize = 1}) async {
    List<Artist> artists = [];
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint?page=$pageSize"));

      if (response.statusCode == 200) {
        final items = json.decode(response.body) as List;

        artists = items.map((value) {
          return Artist.fromJson(value);
        }).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtists",
        errorInfo: e.toString(),
        className: className,
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
        fileName: fileName,
        functionName: "getAlbums",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return albums;
  }

  Future getArtistAlbums(apiEndPoint, artistId) async {
    List<Album> albums = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(Uri.parse(
          "$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artistId"));

      if (response.statusCode == 200) {
        final items = json.decode(response.body) as List;

        // filter albums with no tracks
        for (var album in items) {
          if (int.parse(album['noOfTracks'].toString()) > 0) {
            albums.add(
              Album(
                artist: album['artist_name'],
                artist_id: album['artist_id'],
                count: album['noOfTracks'],
                cover: album['album_coverImage'],
                description: album['album_description'],
                id: album['id'],
                isPurchasedByUser: album['is_purchasedByUser'],
                price: album['album_price'],
                title: album['album_name'],
              ),
            );
          }
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistAlbums",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return albums;
  }

  Future getArtistAlbumsTracks(apiEndPoint, artistId) async {
    List<Album> album = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(Uri.parse(
          "$kinMusicBaseUrl$apiEndPoint?userId=$uid&artistId=$artistId"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

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
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistAlbumsTracks",
        errorInfo: e.toString(),
        className: className,
      );
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
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getMusicByGenreID",
        errorInfo: e.toString(),
        className: className,
      );
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
      "artist_id": {music.artist_id: music.artist_id},
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

  Future<List<Music>> getPurchasedTracks(
      {required String apiEndPoint, required int pageKey}) async {
    List<Music> purchasedTracks = [];
    try {
      String uid = await helper.getUserId();

      Response response = await get(
          Uri.parse("$kinMusicBaseUrl/$apiEndPoint?userId=$uid&page=$pageKey"));

      if (response.statusCode == 200) {
        final items = json.decode(response.body) as List;

        purchasedTracks = items.map((e) => Music.fromJson(e)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getPurchasedTracks",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return purchasedTracks;
  }
}
