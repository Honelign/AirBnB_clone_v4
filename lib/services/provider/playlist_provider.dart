import 'package:flutter/widgets.dart';
import 'package:kin_music_player_app/services/network/api/playlist_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_info.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PlayListProvider extends ChangeNotifier {
  bool isLoading = false;
  late int isFavorite;
  List<Music> musics = [];
  List<PlaylistInfo> playlists = [];

  // playlist service
  PlaylistApiService playlistApiService = PlaylistApiService();

  // get playlists of a user
  Future<List<PlaylistInfo>> getPlayList({int pageKey = 1}) async {
    isLoading = true;
    String apiEndPoint = 'mobileApp/playlists';
    playlists = await playlistApiService.getPlayLists(
        apiEndPoint: apiEndPoint, pageKey: pageKey);
    isLoading = false;
    notifyListeners();
    return playlists;
  }

  // create a playlist for a user
  Future createPlayList({required String playlistName}) async {
    String apiEndPoint = 'mobileApp/playlists';

    isLoading = true;
    notifyListeners();

    var result = await playlistApiService.createPlaylist(
      apiEndPoint: apiEndPoint,
      playlistName: playlistName,
    );
    isLoading = false;
    notifyListeners();
    return result;
  }

  // get tracks under playlist
  Future<List<Music>> getTracksUnderPlaylistById(
      {required int playlistId, int pageKey = 1}) async {
    isLoading = true;
    String apiEndPoint = 'mobileApp/tracksByPlaylistId';
    musics = await playlistApiService.getTracksUnderPlaylistById(
        playlistId: playlistId, apiEndPoint: apiEndPoint, pageKey: pageKey);
    isLoading = false;
    notifyListeners();
    return musics;
  }

// add track to playlist
  Future<bool> addMusicToPlaylist(
      {required String playlistId, required String trackId}) async {
    String apiEndPoint = 'mobileApp/tracksByPlaylistId';

    isLoading = true;
    var result = await playlistApiService.addToPlaylist(
      apiEndPoint: apiEndPoint,
      playlistId: playlistId,
      trackId: trackId,
    );
    isLoading = false;
    notifyListeners();
    return result;
  }

  // add multiple tracks to a playlist
  Future<bool> addMultipleMusicToPlaylist({
    required String playlistId,
    required List<String> musicIds,
  }) async {
    String apiEndPoint = 'mobileApp/tracksByPlaylistId';

    isLoading = true;
    var result = await playlistApiService.addMultipleToPlaylist(
        playlistId: playlistId,
        listOfTrackIds: musicIds,
        apiEndPoint: apiEndPoint);
    isLoading = false;
    notifyListeners();
    return result;
  }

  // delete playlist
  Future deletePlaylist({required String playlistId}) async {
    isLoading = true;
    bool response = await playlistApiService
        .removePlaylist('mobileApp/playlists/$playlistId');
    notifyListeners();
    isLoading = false;
    notifyListeners();
    return response;
  }

  Future deleteTrackFromPlaylist({required String trackIdInPlaylist}) async {
    isLoading = true;
    bool response = await playlistApiService.removeTrackFromPlaylist(
        apiEndPoint: 'mobileApp/tracksByPlaylistId/$trackIdInPlaylist');
    isLoading = false;
    notifyListeners();
    return response;
  }
}
