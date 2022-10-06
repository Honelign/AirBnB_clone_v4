import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

class OfflineMusicProvider extends ChangeNotifier {
  bool isLoading = false;
  String currentDownloadFileName = "";
  String currentDownloadProgress = "";

  // download file to private directory
  Future<bool> downloadAudio({required Music music}) async {
    isLoading = true;
    currentDownloadFileName = "File Bro";
    await Future.delayed(const Duration(seconds: 4));
    currentDownloadProgress = "25";

    await Future.delayed(const Duration(seconds: 2));
    currentDownloadProgress = "50";

    await Future.delayed(const Duration(seconds: 2));
    currentDownloadProgress = "75";

    print("Downloading File");

    return false;
  }
}
