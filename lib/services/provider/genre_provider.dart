import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

import '../network/model/genre.dart';

class GenreProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _pageSize = 10;
  List<Genre> albums = [];
  MusicApiService musicApiService = MusicApiService();
  Future<List<Genre>> getAllGenres() async {
    const String apiEndPoint = 'mobileApp/genres';
    isLoading = true;
    List<Genre> genres = await musicApiService.getGenres(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return genres;
  }

  Future<List<Music>> getAllTracksByGenreId() async {
    const String apiEndPoint = '/mobileApp/tracksByGenreId';
    isLoading = true;
    List<Music> allTracksUnderGenre = await musicApiService.getMusicByGenreID(
      apiEndPoint: apiEndPoint,
      genreId: "1",
    );

    isLoading = false;
    notifyListeners();
    return allTracksUnderGenre;
  }
}
