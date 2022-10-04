import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

import '../network/model/genre.dart';

class GenreProvider extends ChangeNotifier {
  // music api service
  MusicApiService musicApiService = MusicApiService();

  // loading
  bool isLoading = false;

  // all genres
  List<Genre> genres = [];

  // all tracks under genre
  List<Music> allTracksUnderGenre = [];

  // get all genres
  Future<List<Genre>> getAllGenres({int pageKey = 1}) async {
    // endpoint
    const String apiEndPoint = 'mobileApp/genres';

    isLoading = true;
    // make api call
    genres = await musicApiService.getGenres(
        apiEndPoint: apiEndPoint, pageKey: pageKey);
    isLoading = false;
    notifyListeners();
    return genres;
  }

  // get all tracks under genre -> by genreId
  Future<List<Music>> getAllTracksByGenreId(
      {required String genreId, required int pageKey}) async {
    // endpoint
    const String apiEndPoint = '/mobileApp/tracksByGenreId';

    isLoading = true;

    // make api call
    allTracksUnderGenre = await musicApiService.getMusicByGenreID(
      apiEndPoint: apiEndPoint,
      genreId: genreId,
      pageKey: pageKey,
    );

    isLoading = false;
    notifyListeners();
    return allTracksUnderGenre;
  }
}
