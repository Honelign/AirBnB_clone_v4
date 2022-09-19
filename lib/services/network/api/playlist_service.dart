import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';

class PlaylistApiService {
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

  Future addToPlaylist(apiEndPoint, playlistInfo) async {
    Response response = await post(
      Uri.parse("$kinMusicBaseUrl/$apiEndPoint"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      encoding: Encoding.getByName("utf-8"),
      body: json.encode(playlistInfo),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future createPlaylist(apiEndPoint, title, id) async {
    Response response = await post(
      Uri.parse("$kinMusicBaseUrl/api" "$apiEndPoint"),
      body: json.encode(
        {"playlist_name": title.toString(), "user_id": id},
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return 'Successful';
    } else {
      return 'PlayList Title Already Exists';
    }
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

  Future getPlayLists(apiEndPoint) async {
    Response response =
        await get(Uri.parse("$kinMusicBaseUrl/" "$apiEndPoint"));

    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      item.forEach((playlistTitle) {
        List playlistList = [];
        playlistTitle['playlists'] = [];
        playlistTitle['Tracks'].forEach((track) {
          Map<String, dynamic> playlistInfo = {};

          playlistInfo['playlist_id'] = playlistTitle['playlist_id'];
          playlistInfo['playlist_music'] = track;
          playlistList.add(playlistInfo);
        });
        playlistTitle['playlists'] = playlistList;
        playlistTitle.remove("Tracks");
      });

      List<PlaylistTitle> playlists = item.map((value) {
        return PlaylistTitle.fromJson(value);
      }).toList();

      return playlists;
    } else {}
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
