import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/model/music/favorite.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

class FavoriteApiService {
  String fileName = "favourite_service.dart";
  String className = "FavoriteApiService";
  //
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  //
  Future getFavoriteMusics(apiEndPoint, id) async {
    List<Favorite> items = [];
    try {
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint?userId=$id"));

      if (response.statusCode == 200) {
        var res = json.decode(response.body);

        if (res != null) {
          for (var element in res) {
            Music currentMusic = Music.fromJson(element);
            Favorite currentFav =
                Favorite(id: element['fav_id'].toString(), music: currentMusic);

            items.add(currentFav);
          }

          return items;
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getFavoriteMusics",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return items;
  }

  Future deleteFavMusic(apiEndPoint, musicId, userId) async {
    try {
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl/mobileApp/favTracks?userId=$userId"));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        List music = body
            .where(
              (fav) =>
                  fav['track_id'] ==
                  int.parse(
                    musicId.toString(),
                  ),
            )
            .toList();

        var id = music[0]['fav_id'];

        Response response2 =
            await delete(Uri.parse("$kinMusicBaseUrl/mobileApp/favTracks/$id"));

        if (response2.statusCode == 200) {
          print('deleted');
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "deleteFavMusic",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  Future markusFavMusic(apiEndPoint, musicId, userId) async {
    try {
      var body = json.encode({'user_FUI': userId, 'track_id': musicId});
      Response response = await post(
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?userId=$userId"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
          body: body);

      if (response.statusCode == 201) {}
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "markusFavMusic",
        errorInfo: e.toString(),
        className: className,
      );
    }
  }

  Future<int> isMusicFavorite(apiEndPoint, musicid) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        var responses = res['Tracks'].where((favmusic) =>
            favmusic['track_id'].toString() == musicid.toString());

        return responses.length;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }
}
