import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineMusicService {
  String fileName = "offline_music_service.dart";
  String className = "OfflineMusicService";

  //
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  Future<bool> checkTrackInOfflineCache({required String id}) async {
    List filter = [];
    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      String uid = await helper.getUserId();
      List allOfflineTracks =
          jsonDecode(instance.getString("offline-access-${uid}") ?? "[]");

      filter = allOfflineTracks
          .where((element) => element['id'].toString() == id.toString())
          .toList();
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "checkTrackInOfflineCache",
        errorInfo: e.toString(),
      );
    }

    return filter.isNotEmpty;
  }

  // save to cache
  Future<bool> saveOfflineMusicInfoToCache({required Music music}) async {
    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      String uid = await helper.getUserId();

      List allOfflineTracks =
          jsonDecode(instance.getString("offline-access-${uid}") ?? "[]");

      List filter = allOfflineTracks
          .where((element) => element['id'].toString() == music.id.toString())
          .toList();

      if (filter.isEmpty) {
        allOfflineTracks.add(music.toJson());
        instance.setString(
            "offline-access-${uid}", jsonEncode(allOfflineTracks));
      }

      return true;
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "saveOfflineMusicInfoToCache",
        errorInfo: e.toString(),
        className: className,
      );
      return false;
    }
  }

  Future<List<Music>> getOfflineMusic() async {
    List<Music> offlineMusic = [];
    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      String uid = await helper.getUserId();

      List allOfflineTracks =
          jsonDecode(instance.getString("offline-access-${uid}") ?? "[]");

      offlineMusic =
          allOfflineTracks.map((music) => Music.fromJson(music)).toList();
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getOfflineMusic",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return offlineMusic;
  }

  Future<List<Music>> removeOfflineMusic({required Music music}) async {
    List<Music> allMusic = [];

    try {
      final path = File(music.audio);
      await path.delete();

      SharedPreferences instance = await SharedPreferences.getInstance();
      String uid = await helper.getUserId();

      List allOfflineTracks =
          jsonDecode(instance.getString("offline-access-${uid}") ?? "[]");

      List filtered = allOfflineTracks
          .where((e) => e['id'].toString() != music.id.toString())
          .toList();

      instance.setString("offline-access-${uid}", jsonEncode(filtered));
      allMusic = filtered.map((e) => Music.fromJson(e)).toList();
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "removeOfflineMusic",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return allMusic;
  }

  Future<bool> clearOfflineCache() async {
    try {
      SharedPreferences instance = await SharedPreferences.getInstance();
      String uid = await helper.getUserId();

      instance.setString("offline-access-${uid}", "[]");
      return true;
    } catch (e) {
      return false;
    }
  }
}
