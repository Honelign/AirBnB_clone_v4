import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/recently_played_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class MusicProvider extends ChangeNotifier {
  bool isLoading = false;
  late int isFavorite;
  bool hasfinishedtyping = false;
  String value = '';
  List<dynamic> searchedMusics = [];
  List<dynamic>? searchedTracks = [];
  List<dynamic>? searchedArtist = [];
  List<dynamic>? searchedAlbum = [];
  List<Music> albumMusics = [];

  int count = -1;
  Music music = Music(
    artist_id: '',
    artist: '',
    audio: '',
    cover: '',
    description: '',
    id: 2,
    isPurchasedByUser: true,
    priceETB: '5',
    title: 'men',
    albumId: '2',
    genreId: '1',
    encoder_id: "",
  );

  MusicApiService musicApiService = MusicApiService();

  // get new music
  Future<List<Music>> getNewMusics({int pageKey = 1}) async {
    const String apiEndPoint = '/mobileApp/tracks';
    isLoading = true;
    List<Music> musics = await musicApiService.getMusic(
        apiEndPoint: apiEndPoint, pageKey: pageKey);
    isLoading = false;
    notifyListeners();
    return musics;
  }

  // popular
  Future<List<Music>> getPopularMusic() async {
    // const String apiEndPoint = '/mobileApp/popular_tracks';
    const String apiEndPoint = '/mobileApp/tracks';
    isLoading = true;

    // TODO: Replace
    List<Music> musics =
        await musicApiService.getMusic(apiEndPoint: apiEndPoint, pageKey: 1);
    isLoading = false;
    notifyListeners();
    return musics;
  }

  //get music for artist page with album id
  Future<List<Music>> getAlbumMusic(String album_id) async {
    const String apiEndPoint = '/mobile_app/popular_tracks';
    isLoading = true;

    List<Music> albumTracks =
        await musicApiService.getAlbumMusic(apiEndPoint, album_id);
    isLoading = false;
    notifyListeners();
    return albumTracks;
  }

  Future searchedMusic(keyword, searchType) async {
    String apiEndPoint = "/search/$searchType/$keyword/";
    isLoading = true;
    searchedMusics = await searchMusic(apiEndPoint, keyword);
    isLoading = false;
    notifyListeners();
    return searchedMusics;
  }

  // count play
  void countPopular({required Music music}) async {
    await Future.delayed(
      const Duration(
        seconds: popularCountWaitDuration,
      ),
    );

    var result = await musicApiService.addPopularCount(music: music);
  }

  // add to recently played
  void addToRecentlyPlayed({required Music music}) async {
    await Future.delayed(
      const Duration(
        seconds: recentlyPlayedWaitDuration,
      ),
    );

    final provider = RecentlyPlayedProvider();

    provider.addToRecentlyPlayed(
      music.toJson(),
    );
  }

  Future<List?> searchedTrack(title) async {
    searchedTracks = await fetchSearchedTracks(title);

    notifyListeners();
    return searchedTracks ?? [];
  }

  Future<List?> searchedArtists(title) async {
    searchedArtist = await fetchSearchedArtists(title);

    notifyListeners();
    return searchedArtist ?? [];
  }

  Future<List?> searchedAlbums(title) async {
    searchedAlbum = await fetchSearchedAlbums(title);

    notifyListeners();
    return searchedAlbum ?? [];
  }

  Future<int> searchedtrackcount(title) async {
    count = await fetchSearchedTrackscount(title);
    notifyListeners();
    return count;
  }

  Future<List<Music>> albumMusicsGetter(id) async {
    isLoading = true;
    albumMusics = await fetchAlbumMusics(id);
    isLoading = false;
    notifyListeners();
    return albumMusics;
  }
}
