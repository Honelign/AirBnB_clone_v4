import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/api/offline_music_service.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

class OfflineMusicProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Music> offlineMusic = [];

  final OfflineMusicService _offlineMusicService = OfflineMusicService();

  Future<bool> checkTrackInOfflineCache({required String musicId}) async {
    isLoading = true;
    bool result =
        await _offlineMusicService.checkTrackInOfflineCache(id: musicId);

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<bool> saveOfflineMusicInfoToCache({required Music music}) async {
    isLoading = true;

    var result =
        await _offlineMusicService.saveOfflineMusicInfoToCache(music: music);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<List<Music>> getOfflineMusic() async {
    isLoading = true;
    offlineMusic = await _offlineMusicService.getOfflineMusic();
    isLoading = false;
    notifyListeners();
    return offlineMusic;
  }

  Future<bool> removeOfflineMusic({required Music music}) async {
    isLoading = true;
    offlineMusic = await _offlineMusicService.removeOfflineMusic(music: music);
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> clearCache() async {
    isLoading = true;

    bool result = await _offlineMusicService.clearOfflineCache();
    isLoading = false;
    notifyListeners();
    return result;
  }
}
