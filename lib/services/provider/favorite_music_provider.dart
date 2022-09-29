import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/favourite_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMusicProvider extends ChangeNotifier {
  bool isLoading = false;
  int isFavorite = 0;
  List<Favorite> favoriteMusics = [];
  FavoriteApiService favoriteApiService = FavoriteApiService();
  Future<List<Favorite>> getFavMusic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    String apiEndPoint = '/mobileApp/favTracks/';
    isLoading = true;
    notifyListeners();
    favoriteMusics =
        await favoriteApiService.getFavoriteMusics(apiEndPoint, id);
    isLoading = false;
    notifyListeners();
    return favoriteMusics;
  }

  Future unFavMusic(musicId) async {
    isFavorite = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    String apiEndPoint = '/api/favourites/';

    await favoriteApiService.deleteFavMusic(apiEndPoint, musicId, id);

    notifyListeners();
  }

  Future favMusic(musicId) async {
    isFavorite = 1;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');

    String apiEndPoint = '/mobileApp/favTracks/';

    await favoriteApiService.markusFavMusic(apiEndPoint, musicId, id);

    notifyListeners();
  }

  void isMusicFav(musicId) async {
    isFavorite = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getString('id');

    String apiEndPoint = '/favourite/?user=$id';
    isFavorite = await favoriteApiService.isMusicFavorite(apiEndPoint, musicId);

    notifyListeners();
  }
}
