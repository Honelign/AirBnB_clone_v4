import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';
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

  MusicApiService musicApiService = MusicApiService();

  // get new music
  Future<List<Music>> getNewMusics() async {
    const String apiEndPoint = '/mobileApp/tracks';
    isLoading = true;
    List<Music> musics = await musicApiService.getMusic(apiEndPoint);
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
    List musics = await musicApiService.getMusic(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return musics as List<Music>;
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

    SharedPreferences pref = await SharedPreferences.getInstance();
    String id = pref.getString("id") ?? "";

    var result = await musicApiService.addPopularCount(
      track_id: music.id.toString(),
      user_id: id,
    );
    print("@@@@ music_player -> countPopular: Added ${music.title} count");
  }

  // add to recently played
  void addToRecentlyPlayed({required Music music}) async {
    await Future.delayed(
      const Duration(
        seconds: recentlyPlayedWaitDuration,
      ),
    );

    print("@@@${music.title} added to recently played");

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
    isLoading=true;
    albumMusics = await fetchAlbumMusics(id);
    isLoading=false;
    notifyListeners();
    return albumMusics;
  }
}
