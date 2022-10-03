import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/analytics/album_info.dart';
import 'package:kin_music_player_app/services/network/model/analytics/analytics.dart';
import 'package:kin_music_player_app/services/network/model/analytics/artist_info.dart';
import 'package:kin_music_player_app/services/network/model/analytics/music_info.dart';

import '../../../constants.dart';

class AnalyticsApiService {
  final String fileName = "analytics_service.dart";
  final String className = "AnalyticsApiService";

  // error logging service
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  // get total count,revenue and main graph info of producer
  Future getProducerGeneralInfo({
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl/$apiEndPoint?userId=$uid&userType=1"));

      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body,
        );

        analytics = data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getProducerGeneralInfo",
        errorInfo: e.toString(),
      );
    }
    return analytics;
  }

  // get total count,revenue and main graph info of artist
  Future getArtistGeneralInfo({
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$uid&level=2"));

      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body,
        );

        analytics = data.map((value) => AnalyticsData.fromJson(value)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistGeneralInfo",
        errorInfo: e.toString(),
      );
    }
    return analytics;
  }

  // get all artists, albums and tracks under a producer
  Future getProducerOwnedInfo({
    required String apiEndPoint,
    required String typeOfInfo,
  }) async {
    List returnInfo = [];
    try {
      String uid = await helper.getUserId();

      Response response =
          await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint?userId=$uid"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // if albums
        if (typeOfInfo == "Albums") {
          returnInfo = data.map((value) => AlbumInfo.fromJson(value)).toList();
        }

        //
        else if (typeOfInfo == "Tracks") {
          returnInfo = data.map((value) => MusicInfo.fromJson(value)).toList();
        }

        //
        else {
          returnInfo = data.map((value) => ArtistInfo.fromJson(value)).toList();
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistGeneralInfo",
        errorInfo: e.toString(),
      );
    }
    return returnInfo;
  }

  // get info by track id
  Future getTrackInfo({
    required String trackId,
    required String apiEndPoint,
  }) async {
    try {
      Response response =
          await get(Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$trackId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List analytics =
            data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      print("@analytics_service -> getTrackInfo error -$e");
      return [];
    }
  }

  // get info by artist id
  Future getArtistInfo({
    required String artistId,
    required String apiEndPoint,
  }) async {
    try {
      Response response =
          await get(Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$artistId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List analytics =
            data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      print("@analytics_service -> getArtistInfo error - $e");
      return [];
    }
  }

  // get info by artist id
  Future getAlbumInfo({
    required String albumId,
    required String apiEndPoint,
  }) async {
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl/$apiEndPoint?albumId=$albumId"));

      print("@@@@here - $kAnalyticsBaseUrl/$apiEndPoint?albumId=$albumId");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List analytics =
            data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      print("@analytics_service -> ${e}");
      return [];
    }
  }

  Future getArtistOwnedInfo({
    required String userId,
    required String privilege,
    required String apiEndPoint,
  }) async {
    try {
      Response response = await get(
        Uri.parse("$kinMusicBaseUrl$apiEndPoint?id=$userId&level=2"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        data = data.where((item) => item['album_title'] != "Singles").toList();
        List albums = data.map((value) => AlbumInfo.fromJson(value)).toList();
        print("@getArtistOwnedInfo -> $albums");

        return albums;
      }
    } catch (e) {
      print("@analytics_service -> getProducerOwnedInfo error - $e");
      return [];
    }
  }
}
