import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class PlayListProvider extends ChangeNotifier {
  bool isLoading = false;
  late int isFavorite;
  List<PlaylistTitle> musics = [];

  Future<List<PlaylistTitle>> getPlayList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // final id = prefs.getInt('id');
    // const idstatic = 12345;
    // String apiEndPoint = '/playlists/?user=$idstatic';

    final id = prefs.getString('id');
    // const idstatic = 1234;
    String apiEndPoint = '/playlists/?user=$id';

    isLoading = true;
    musics = await getPlayLists(apiEndPoint);
    isLoading = false;

    notifyListeners();
    return musics;
  }

  Future createPlayList(title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    String apiEndPoint = '/playlists/';

    isLoading = true;
    notifyListeners();

    var result = await createPlaylist(apiEndPoint, title, id);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<List<PlayListTitles>> getPlayListTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');
    // const idstatic = 1234;

    String apiEndPoint = 'playlists/?user=$id';
    isLoading = true;
    List<PlayListTitles> titles = await getPlayListTitles(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return titles;
  }

  Future<bool> addMusicToPlaylist(playlistInfo) async {
    String apiEndPoint = 'api/playlisttracks/';

    isLoading = true;
    var result = await addToPlaylist(apiEndPoint, playlistInfo);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future deleteFromPlaylist(playlistId, trackId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('id');

    await removeFromPlaylist('/playlists/?user=$id', playlistId, trackId);

    notifyListeners();
  }

  Future deletePlaylistTitle(playlistTitleId) async {
    await removePlaylistTitle('/playlists/$playlistTitleId');
    notifyListeners();
  }
}
