import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RecentlyPlayedProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _recentlyPlayedMaxCount = 6;

  // get last played
  Future<List<Music>> getRecentlyPlayed() async {
    try {
      isLoading = true;
      SharedPreferences pref = await SharedPreferences.getInstance();

      String id = pref.getString("id") ?? "";
      List<dynamic> musicsJsonList =
          jsonDecode(pref.getString("fav$id") ?? "[]");

      List<Music> recentlyPlayedMusic = musicsJsonList.map((value) {
        return Music.fromJson(value);
      }).toList();

      notifyListeners();
      return List.from(recentlyPlayedMusic.reversed);
    } catch (e) {
      return <Music>[];
    }
  }

  // add new
  Future<List<Music>> addToRecentlyPlayed(
      Map<String, dynamic> newPlayedMusic) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? id = pref.getString("id");
      if (id == null) return [];

      String? favorites = pref.getString("fav$id") ?? "[]";

      List<dynamic> recentlyPlayed = jsonDecode(favorites);

      // check if song in list
      List isInRecentlyPlayed = recentlyPlayed
          .where(
            (track) =>
                track['id'].toString() == newPlayedMusic['id'].toString(),
          )
          .toList();

      if (isInRecentlyPlayed.isEmpty) {
        if (recentlyPlayed.length >= _recentlyPlayedMaxCount) {
          // remove first
          List<Map<String, dynamic>> recentlyPlayedCopy = [];
          for (int i = 1; i < recentlyPlayed.length; i++) {
            recentlyPlayedCopy.add(recentlyPlayed[i]);
          }
          // add new
          recentlyPlayed = recentlyPlayedCopy;
          recentlyPlayed.add(newPlayedMusic);

          // save to var
        } else {
          // add to var
          recentlyPlayed.add(newPlayedMusic);
        }
      } else {}

      pref.setString("fav$id", jsonEncode(recentlyPlayed));
      getRecentlyPlayed();
      notifyListeners();

      return [];
    } catch (e) {
      return [];
    }
  }
}
