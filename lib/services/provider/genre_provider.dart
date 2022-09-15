import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

import '../network/model/genre.dart';

class GenreProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _pageSize = 10;
  List<Genre> albums = [];
  MusicApiService musicApiService = MusicApiService();
  Future<List<Genre>> getGenre() async {
    const String apiEndPoint = '/mobile_app/genres';
    isLoading = true;
    List<Genre> genres = await musicApiService.getGenres(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return genres;
  }
}
