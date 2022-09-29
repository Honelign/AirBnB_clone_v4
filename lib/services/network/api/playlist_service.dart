import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_info.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';

class PlaylistApiService {
  // Error Logging Service
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  // get all playlists of user
  Future<List<PlaylistInfo>> getPlayLists(
      {required String apiEndPoint, required int pageKey}) async {
    List<PlaylistInfo> playlists = [];
    try {
      // get user id
      String uid = await helper.getUserId();

      // make api call
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl/$apiEndPoint?userId=$uid&page=$pageKey"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        playlists = item.map((value) {
          return PlaylistInfo.fromJson(value);
        }).toList();
      }
    } catch (e) {
      // log error to server
      errorLoggingApiService.logErrorToServer(
        fileName: "playlist_service",
        functionName: "getPlayLists",
        errorInfo: e.toString(),
      );
    }
    return playlists;
  }

  // create playlist for a user
  Future createPlaylist(
      {required String apiEndPoint, required String playlistName}) async {
    try {
      // get user id
      String uid = await helper.getUserId();
      Response response = await post(
        Uri.parse("$kinMusicBaseUrl/$apiEndPoint?userId=$uid"),
        body: json.encode(
          {"playlist_name": playlistName.toString(), "user_FUI": uid},
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 201) {
        return 'Successful';
      } else {
        errorLoggingApiService.logErrorToServer(
            fileName: "playlist_service",
            functionName: "createPlaylist",
            errorInfo: jsonDecode(response.body),
            remark: "Status code is ${response.statusCode}");
        return 'Something went wrong. Try again!';
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "playlist_service",
        functionName: "createPlaylist",
        errorInfo: e.toString(),
      );
    }
  }

  // get all tracks under a playlist
  Future getTracksUnderPlaylistById(
      {required String apiEndPoint,
      required int playlistId,
      required int pageKey}) async {
    List<Music> musicUnderPlaylist = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(Uri.parse(
          "$kinMusicBaseUrl/$apiEndPoint?userId=$uid&playlistId=$playlistId&page=$pageKey"));

      if (response.statusCode == 200) {
        List items = jsonDecode(response.body);

        musicUnderPlaylist =
            items.map((tracks) => Music.fromJson(tracks)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
          fileName: "playlist_service",
          functionName: "getTracksUnderPlaylistById",
          errorInfo: e.toString());
    }

    return musicUnderPlaylist;
  }

  // add track to playlist
  Future addToPlaylist(
      {required String apiEndPoint,
      required String playlistId,
      required String trackId}) async {
    try {
      String uid = await helper.getUserId();
      Response response = await post(
        Uri.parse(
            "$kinMusicBaseUrl/$apiEndPoint?userId=$uid&playlistId=$playlistId"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        encoding: Encoding.getByName("utf-8"),
        body: json.encode({"playlist_id": playlistId, "track_id": trackId}),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "playlist_provider",
        functionName: "addToPlaylist",
        errorInfo: e.toString(),
      );
    }
    return false;
  }

  // add multiple tracks to playlist
  Future addMultipleToPlaylist(
      {required String apiEndPoint,
      required String playlistId,
      required List<String> listOfTrackIds}) async {
    try {
      String uid = await helper.getUserId();
      listOfTrackIds.forEach((trackId) async {
        bool res = await addToPlaylist(
            apiEndPoint: apiEndPoint, playlistId: playlistId, trackId: trackId);

        print(res);
      });
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "playlist_service",
        functionName: "addMultipleToPlaylist",
        errorInfo: e.toString(),
      );
    }

    return true;
  }

  Future removeTrackPlaylist(apiEndPoint, playListTrackId) async {
    Response response = await delete(
      Uri.parse("$kinMusicBaseUrl/$apiEndPoint$playListTrackId/"),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future getPlayListTitles(apiEndPoint) async {
    Response response = await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint"));

    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<PlayListTitles> playlistTitles = item.map((value) {
        return PlayListTitles.fromJson(value);
      }).toList();
      return playlistTitles;
    } else {}
  }

  Future removeFromPlaylist(apiEndPoint, playlistId, trackId) async {
    Response response = await get(
      Uri.parse("$kinMusicBaseUrl$apiEndPoint"),
    );

    if (response.statusCode == 200) {
      var resbody = json.decode(response.body) as List;

      for (int j = 0; j < resbody[j].length; j++) {
        if (trackId == resbody[j]['playlist_id']) {
          var tracks = resbody[j]['Tracks'];

          for (int i = 0; i < resbody[j]['Tracks'].length; i++) {
            if (playlistId == tracks[i]['track_id']) {
              var playListTrackId = tracks[i]['playlisttracks_id'];

              var apiEndPoint = 'api/playlisttracks/';
              Response response = await delete(
                Uri.parse("$kinMusicBaseUrl/$apiEndPoint$playListTrackId/"),
              );

              if (response.statusCode == 204) {
                return true;
              } else {
                return false;
              }
              // removeTrackPlaylist(apiEndPoint, playListTrackId);

            }
          }
        }
      }
    }
  }

  Future removePlaylistTitle(apiEndPoint) async {
    Response response = await delete(
      Uri.parse("$kinMusicBaseUrl/api" "$apiEndPoint/"),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
