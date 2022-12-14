import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/api/favourite_service.dart';
import 'package:kin_music_player_app/services/network/model/music/favorite.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CachedFavoriteProvider extends ChangeNotifier {
  List<dynamic> favMusics = [];
  FavoriteApiService favoriteApiService = FavoriteApiService();
// ignore: avoid_types_as_parameter_names
  void cacheFavorite() async {
    SharedPreferences prefss = await SharedPreferences.getInstance();
    final id = prefss.getString('id');

    String apiEndPoint = '/mobileApp/favTracks?userId=$id';

    List<Favorite> fav =
        await favoriteApiService.getFavoriteMusics(apiEndPoint, id);

    List<int> favmusicIds = [];

    for (var favorite in fav) {
      // favorite.music.forEach((music) {
      //   favmusicIds.add(music.id);
      // });

      favmusicIds.add(favorite.music.id);
    }

    String favMusics = jsonEncode(favmusicIds);
    prefss.setString('fav', favMusics);

    notifyListeners();
  }

  void addCachedFav(id) async {
    final prefs = await SharedPreferences.getInstance();

    String? favorites = prefs.getString("fav") ?? "[]";
    List<dynamic> favMusics = jsonDecode(favorites);
    favMusics.add(id);
    String fav = jsonEncode(favMusics);
    prefs.setString('fav', fav);
    notifyListeners();
  }

  void removeCachedFav(id) async {
    final prefs = await SharedPreferences.getInstance();
    String? favorites = prefs.getString("fav") ?? "[]";
    List<dynamic> favMusics = jsonDecode(favorites);
    favMusics.remove(id);
    String fav = jsonEncode(favMusics);
    prefs.setString('fav', fav);
    notifyListeners();
  }

  Future<List> getFavids() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? favorites = prefs.getString('fav') ?? '[]';
      favMusics = jsonDecode(favorites);

      notifyListeners();
      return favMusics;
    } catch (e) {
      return [];
    }
  }
}
