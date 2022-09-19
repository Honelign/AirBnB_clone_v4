import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';

class FavoriteApiService {
  Future getFavoriteMusics(apiEndPoint, id) async {
    Response response =
        await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint?user=$id"));

    try {
      List<Map<String, dynamic>> item = [];
      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        if (res != null) {
          item.add(res);

          List<Favorite> musics = item.map((value) {
            return Favorite.fromJson(value);
          }).toList();

          return musics;
        } else {
          return <Favorite>[];
        }
      } else {
        return <Favorite>[];
      }
    } catch (e) {
      print("@api_service--getFavMusic" + e.toString());
      return <Favorite>[];
    }
  }

  Future deleteFavMusic(apiEndPoint, musicId, userId) async {
    Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);

      List music = body['results']
          .where(
            (fav) =>
                fav['user_id'] == userId.toString() &&
                fav['track_id'] ==
                    int.parse(
                      musicId.toString(),
                    ),
          )
          .toList();

      var id = music[0]['id'];

      Response response2 =
          await delete(Uri.parse("$kinMusicBaseUrl/api/favourites/$id/"));
      if (response2.statusCode == 200) {
      } else {}
    } else {}
  }

  Future markusFavMusic(apiEndPoint, musicId, userId) async {
    var body = json.encode({'user_id': userId, 'track_id': musicId});
    Response response = await post(Uri.parse("$kinMusicBaseUrl$apiEndPoint"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: body);

    if (response.statusCode == 201) {
    } else {}
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
