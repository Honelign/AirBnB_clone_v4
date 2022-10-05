import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/analytics/album_info.dart';
import 'package:kin_music_player_app/services/network/model/analytics/analytics.dart';
import 'package:kin_music_player_app/services/network/model/analytics/artist_info.dart';
import 'package:kin_music_player_app/services/network/model/analytics/music_info.dart';

import '../../../constants.dart';

class AnalyticsApiService {
  String fileName = "analytics_service.dart";
  String className = "AnalyticsApiService";

  // get total count,revenue and main graph info of a producer
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
        className: className,
      );
    }
    return analytics;
  }

  // get total count,revenue and main graph info of an artist
  Future getArtistGeneralInfo({
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?userId=$uid&userType=2"));

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
        functionName: "getArtistGeneralInfo",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return analytics;
  }

  // get all artists, albums and tracks under a producer
  Future getProducerOwnedInfo({
    required String infoType,
    required String apiEndPoint,
  }) async {
    List returnInfo = [];
    try {
      String uid = await helper.getUserId();
      Response response =
          await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint?userId=$uid"));

      print("@@@here - $kinMusicBaseUrl/$apiEndPoint?userId=$uid");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // artist value

        // album info
        if (infoType == "Albums") {
          returnInfo = data.map((value) => AlbumInfo.fromJson(value)).toList();
        }

        // track info
        else if (infoType == "Tracks") {
          returnInfo = data.map((value) => MusicInfo.fromJson(value)).toList();
        }

        // else
        else {
          returnInfo = data.map((value) => ArtistInfo.fromJson(value)).toList();
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getProducerOwnedInfo",
        errorInfo: e.toString(),
        className: className,
        remark: "Info type is $infoType",
      );
    }

    return returnInfo;
  }

  // get all  albums and tracks under an artist
  Future getArtistOwnedInfo({
    required String infoType,
    required String apiEndPoint,
  }) async {
    List returnInfo = [];
    try {
      String uid = await helper.getUserId();
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?userId=$uid&level=2"));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        data = data.where((item) => item['album_title'] != "Singles").toList();

        if (infoType == "Tracks") {
          returnInfo = data.map((value) => MusicInfo.fromJson(value)).toList();
        }

        //
        else {
          returnInfo = data.map((value) => AlbumInfo.fromJson(value)).toList();
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistOwnedInfo",
        errorInfo: e.toString(),
        className: className,
        remark: "Info type is $infoType",
      );
    }
    return returnInfo;
  }

  // get info by artist id
  Future getArtistInfo({
    required String artistId,
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl/$apiEndPoint?artistId=$artistId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        analytics = data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getArtistInfo",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return analytics;
  }

  // get info by artist id
  Future getAlbumInfo({
    required String albumId,
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl/$apiEndPoint?albumId=$albumId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        analytics = data.map((value) => AnalyticsData.fromJson(value)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getAlbumInfo",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return analytics;
  }

  // get info by track id
  Future getTrackInfo({
    required String trackId,
    required String apiEndPoint,
  }) async {
    List analytics = [];
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl/$apiEndPoint?trackId=$trackId"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        analytics = data.map((value) => AnalyticsData.fromJson(value)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getTrackInfo",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return analytics;
  }
}
