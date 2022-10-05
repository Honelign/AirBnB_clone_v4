import 'dart:convert';
import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/network/model/music/playlist_info.dart';

class PlaylistApiService {
  //
  String className = "PlaylistApiService";
  String fileName = "playlist_service.dart";

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
        fileName: fileName,
        functionName: "getPlayLists",
        errorInfo: e.toString(),
        className: className,
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
            fileName: fileName,
            functionName: "createPlaylist",
            errorInfo: jsonDecode(response.body),
            remark: "Status code is ${response.statusCode}");
        return 'Something went wrong. Try again!';
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
          fileName: fileName,
          functionName: "createPlaylist",
          errorInfo: e.toString(),
          className: className);
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
        fileName: fileName,
        functionName: "getTracksUnderPlaylistById",
        errorInfo: e.toString(),
        className: className,
      );
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

      if (response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
          fileName: fileName,
          functionName: "addToPlaylist",
          errorInfo: e.toString(),
          className: className);
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
      });
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "addMultipleToPlaylist",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return true;
  }

  // delete playlist itself
  Future removePlaylist(apiEndPoint) async {
    try {
      Response response = await delete(
        Uri.parse("$kinMusicBaseUrl/$apiEndPoint"),
      );

      if (response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "playlist_service",
        functionName: "removePlaylist",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return false;
  }

// delete track from playlist
  Future removeTrackFromPlaylist({required String apiEndPoint}) async {
    try {
      Response response = await delete(
        Uri.parse("$kinMusicBaseUrl/$apiEndPoint"),
      );

      if (response.statusCode == 204) {
        return true;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "removeTrackFromPlaylist",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return false;
  }
}
