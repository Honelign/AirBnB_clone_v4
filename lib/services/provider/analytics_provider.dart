import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsProvider extends ChangeNotifier {
  bool isLoading = false;
  List producerOwnedInfo = [];
  List allArtists = [];
  List allAlbums = [];
  List allTracks = [];
  List generalAnalytics = [];

  List currentTrackAnalytics = [];
  List currentArtistAnalytics = [];
  List currentAlbumAnalytics = [];

  final String totalViewCountApiEndPoint = "totalViewCountByUserId";

  AnalyticsApiService analyticsApiService = AnalyticsApiService();

  // get total count,revenue and main graph info of producer
  Future getProducerGeneralInfo() async {
    isLoading = true;

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getProducerGeneralInfo(
      apiEndPoint: totalViewCountApiEndPoint,
    );
    isLoading = false;

    return generalAnalytics;
  }

  // get total count,revenue and main graph info of artist
  Future getArtistGeneralInfo() async {
    isLoading = true;

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getArtistGeneralInfo(
      apiEndPoint: totalViewCountApiEndPoint,
    );
    isLoading = false;

    return generalAnalytics;
  }

  // get all artists, albums and tracks under a producer
  Future getProducerOwnedInfo({required String typeOfInfo}) async {
    isLoading = true;
    allArtists = [];
    allAlbums = [];
    allTracks = [];

    String apiEndPoint = "mobileApp/artistsByUserId";

    if (typeOfInfo == "Albums") {
      apiEndPoint = "mobileApp/albumsByUserId";
    } else if (typeOfInfo == "Tracks") {
      apiEndPoint = "mobileApp/tracksByUserId";
    }

    // make api call
    var producerOwnedInfo = await analyticsApiService.getProducerOwnedInfo(
      apiEndPoint: apiEndPoint,
      typeOfInfo: typeOfInfo,
    );

    isLoading = false;

    if (typeOfInfo == "Albums") {
      allAlbums = producerOwnedInfo;
    }

    //
    else if (typeOfInfo == "Tracks") {
      allTracks = producerOwnedInfo;
    }

    //
    else {
      allArtists = producerOwnedInfo;
    }
  }

  // get count and view of an artist
  Future getArtistAnalyticsInfo({required String artistId}) async {
    isLoading = true;
    currentArtistAnalytics = [];
    currentArtistAnalytics = await analyticsApiService.getArtistInfo(
      artistId: artistId,
      apiEndPoint: '/total_artist_count',
    );
    isLoading = false;

    return currentArtistAnalytics;
  }

  // get count and view of an album
  Future getAlbumAnalyticsInfo({required String albumId}) async {
    isLoading = true;
    currentAlbumAnalytics = [];
    currentAlbumAnalytics = await analyticsApiService.getAlbumInfo(
      albumId: albumId,
      apiEndPoint: 'totalAlbumViewCount',
    );
    isLoading = false;

    return currentAlbumAnalytics;
  }

  // get analytics of track
  Future getTrackAnalyticsInfo({required String trackId}) async {
    isLoading = true;
    currentTrackAnalytics = [];
    currentTrackAnalytics = await analyticsApiService.getTrackInfo(
      trackId: trackId,
      apiEndPoint: '/total_track_count',
    );
    isLoading = false;

    return currentTrackAnalytics;
  }

  Future getArtistOwnedInfo() async {
    isLoading = true;
    allArtists = [];
    allAlbums = [];
    allTracks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get user id
    String uid = prefs.getString("id") ?? "";

    // get user prev
    String privilege = prefs.getString("prev") ?? "2";

    // make api call
    var artistOwnedInfo = await analyticsApiService.getArtistOwnedInfo(
      userId: uid,
      privilege: privilege,
      apiEndPoint: totalViewCountApiEndPoint,
    );

    isLoading = false;

    // arrange info

    artistOwnedInfo.forEach((album) {
      allAlbums.add(album);

      album.musics.forEach((music) {
        allTracks.add(music);
      });
    });
  }
}
