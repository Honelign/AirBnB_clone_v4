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

  Future getProducerGeneralInfo() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get user id
    String uid = prefs.getString("id") ?? "";

    // get user prev
    String privilege = prefs.getString("prev") ?? "1";

    //
    String apiEndPoint = "/total_count_by_userid";

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getProducerGeneralInfo(
        userId: uid, privilege: privilege, apiEndPoint: apiEndPoint);
    isLoading = false;

    return generalAnalytics;
  }

  Future getArtistGeneralInfo() async {
    isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // get user id
    String uid = prefs.getString("id") ?? "";

    // get user prev
    String privilege = prefs.getString("prev") ?? "2";

    //
    String apiEndPoint = "/total_count_by_userid";

    generalAnalytics = [];
    generalAnalytics = await analyticsApiService.getArtistGeneralInfo(
        userId: uid, privilege: privilege, apiEndPoint: apiEndPoint);
    isLoading = false;

    return generalAnalytics;
  }

  Future getProducerOwnedInfo() async {
    isLoading = true;
    allArtists = [];
    allAlbums = [];
    allTracks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get user id
    String uid = prefs.getString("id") ?? "";

    // get user prev
    String privilege = prefs.getString("prev") ?? "1";

    // make api call
    var producerOwnedInfo = await analyticsApiService.getProducerOwnedInfo(
      userId: uid,
      privilege: privilege,
      apiEndPoint: apiEndPoint,
    );

    isLoading = false;

    // arrange info
    producerOwnedInfo.forEach((artist) {
      allArtists.add(artist);

      artist.albums.forEach((album) {
        allAlbums.add(album);

        album.musics.forEach((music) {
          allTracks.add(music);
        });
      });
    });
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
      apiEndPoint: apiEndPoint,
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
