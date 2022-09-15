import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';

class DropDownProvider extends ChangeNotifier {
  PlaylistTitle ? _playlist;
  int _playlistId = 1;

  void setPlaylist(PlaylistTitle playlist) {
    _playlist = playlist;
    _playlistId = playlist.id;
    notifyListeners();
  }

  PlaylistTitle? get dropdownTitle {
  return _playlist;

}
  get playlistId => _playlistId;
}
