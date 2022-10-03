import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsProvider extends ChangeNotifier {
  final String apiEndPoint = "/mobileApp/data_by_userid";
  bool isLoading = false;
  List producerOwnedInfo = [];
  List allArtists = [];
  List allAlbums = [];
  List allTracks = [];
  List generalAnalytics = [];

  List currentTrackAnalytics = [];
  List currentArtistAnalytics = [];
  List currentAlbumAnalytics = [];

  AnalyticsApiService analyticsApiService = AnalyticsApiService();

  //
  final String generalInfoApiEndPoint = "totalViewCountByUserId";

  // get total count,revenue and main graph info of a producer
  Future getProducerGeneralInfo() async {
    isLoading = true;

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getProducerGeneralInfo(
        apiEndPoint: generalInfoApiEndPoint);
    isLoading = false;

    return generalAnalytics;
  }

  // get total count,revenue and main graph info of an artist
  Future getArtistGeneralInfo() async {
    isLoading = true;

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getArtistGeneralInfo(
        apiEndPoint: generalInfoApiEndPoint);
    isLoading = false;

    return generalAnalytics;
  }

  // get all artists, albums and tracks under a producer
  Future getProducerOwnedInfo({required String infoType}) async {
    isLoading = true;
    allArtists = [];
    allAlbums = [];
    allTracks = [];

    String apiEndPoint = "artists";

    if (infoType == "Albums") {
      apiEndPoint = "albums";
    }

    //
    else if (infoType == "Tracks") {
      apiEndPoint = "tracks";
    }

    // make api call
    var producerOwnedInfo = await analyticsApiService.getProducerOwnedInfo(
      infoType: infoType,
      apiEndPoint: apiEndPoint,
    );

    isLoading = false;

    if (infoType == "Albums") {
      allAlbums = producerOwnedInfo;
    }

    //
    else if (infoType == "Tracks") {
      allTracks = producerOwnedInfo;
    }

    //
    else {
      allArtists = producerOwnedInfo;
    }
    isLoading = false;
    notifyListeners();
    return producerOwnedInfo;
  }

  // get all  albums and tracks under an artist
  Future getArtistOwnedInfo({required String infoType}) async {
    isLoading = true;
    allArtists = [];
    allAlbums = [];
    allTracks = [];

    // make api call
    var artistOwnedInfo = await analyticsApiService.getArtistOwnedInfo(
      infoType: infoType,
      apiEndPoint: apiEndPoint,
    );

    isLoading = false;

    // arrange info

    if (infoType == "Tracks") {
      allTracks = artistOwnedInfo;
    }

    //
    else {
      allAlbums = artistOwnedInfo;
    }

    isLoading = false;
    notifyListeners();
  }

  // get analytics of an artist
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

  // get analytics of an album
  Future getAlbumAnalyticsInfo({required String albumId}) async {
    isLoading = true;
    currentAlbumAnalytics = [];
    currentAlbumAnalytics = await analyticsApiService.getAlbumInfo(
      albumId: albumId,
      apiEndPoint: '/total_album_count',
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
}
