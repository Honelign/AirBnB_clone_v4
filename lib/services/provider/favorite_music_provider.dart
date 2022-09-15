import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMusicProvider extends ChangeNotifier {
  bool isLoading = false;
  int isFavorite = 0;
  List<Favorite> favoriteMusics = [];
  Future<List<Favorite>> getFavMusic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    String apiEndPoint = '/favourite/';
    isLoading = true;
    notifyListeners();
    favoriteMusics = await getFavoriteMusics(apiEndPoint, id);
    isLoading = false;
    notifyListeners();
    return favoriteMusics;
  }

  Future unFavMusic(musicId) async {
    isFavorite = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    String apiEndPoint = '/api/favourites/';

    await deleteFavMusic(apiEndPoint, musicId, id);

    notifyListeners();
  }

  Future favMusic(musicId) async {
    isFavorite = 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');

    String apiEndPoint = '/api/favourites/';

    await markusFavMusic(apiEndPoint, musicId, id);

    notifyListeners();
  }

  void isMusicFav(musicId) async {
    isFavorite = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');

    String apiEndPoint = '/favourite/?user=$id';
    isFavorite = await isMusicFavorite(apiEndPoint, musicId);

    notifyListeners();
  }
}
