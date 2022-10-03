import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/model/analytics/album_info.dart';
import 'package:kin_music_player_app/services/network/model/analytics/analytics.dart';
import 'package:kin_music_player_app/services/network/model/analytics/artist_info.dart';

import '../../../constants.dart';

class AnalyticsApiService {
  String fileName = "analytics_service.dart";
  String className = "AnalyticsApiService";

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
      Response response =
          await get(Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$albumId"));

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

  // get total count,revenue and main graph info
  Future getProducerGeneralInfo({
    required String userId,
    required String privilege,
    required String apiEndPoint,
  }) async {
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$userId&level=1"));

      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body,
        );

        List analytics =
            data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      print("@analytics_service -> getProducerGeneralInfo error - $e");
      return [];
    }
  }

  Future getArtistGeneralInfo({
    required String userId,
    required String privilege,
    required String apiEndPoint,
  }) async {
    try {
      Response response = await get(
          Uri.parse("$kAnalyticsBaseUrl$apiEndPoint?id=$userId&level=2"));

      if (response.statusCode == 200) {
        var data = jsonDecode(
          response.body,
        );

        List analytics =
            data.map((value) => AnalyticsData.fromJson(value)).toList();

        return analytics;
      }
    } catch (e) {
      print("@analytics_service -> getProducerGeneralInfo error - $e");
      return [];
    }
  }

  // get all artists, albums and tracks under a producer
  Future getProducerOwnedInfo({
    required String userId,
    required String privilege,
    required String apiEndPoint,
  }) async {
    try {
      Response response = await get(
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?id=$userId&level=1"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List artists = data.map((value) => ArtistInfo.fromJson(value)).toList();

        return artists;
      }
    } catch (e) {
      print("@analytics_service -> getProducerOwnedInfo error - $e");
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
          Uri.parse("$kinMusicBaseUrl$apiEndPoint?id=$userId&level=2"));

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
