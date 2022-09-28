import 'package:flutter/widgets.dart';
import 'package:kin_music_player_app/services/network/api/playlist_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_info.dart';

import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
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

  Future<bool> addMusicToPlaylist(playlistInfo) async {
    String apiEndPoint = 'api/playlisttracks/';

    isLoading = true;
    var result =
        await playlistApiService.addToPlaylist(apiEndPoint, playlistInfo);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future deleteFromPlaylist(playlistId, trackId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    await playlistApiService.removeFromPlaylist(
        '/playlists/?user=$id', playlistId, trackId);

    notifyListeners();
  }

  Future deletePlaylistTitle(playlistTitleId) async {
    await playlistApiService.removePlaylistTitle('/playlists/$playlistTitleId');
    notifyListeners();
  }
}
