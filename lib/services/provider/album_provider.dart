import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';

class AlbumProvider extends ChangeNotifier {
  List<Album> albums = [];

  bool isLoading = false;

  Album searchAlbum = Album(
      id: 5,
      count: 5,
      title: 'title',
      artist: 'artist',
      description: 'description',
      cover: 'cover',
      artist_id: 1,
      price: 5,
      isPurchasedByUser: false);

  MusicApiService musicApiService = MusicApiService();
  List albumMusics = [];

// get new albums
  Future<List<Album>> getAlbums({required int pageSize}) async {
    const String apiEndPoint = '/mobileApp/albums';
    isLoading = true;

    List<Album> albums = await musicApiService.getAlbums(
        apiEndPoint: apiEndPoint, pageSize: pageSize);
    isLoading = false;

    notifyListeners();
    return albums;
  }

  //get albums for artist
  Future<List<Album>> getArtistAlbums(String artistId) async {
    const String apiEndPoint = '/mobileApp/albumByArtistId';
    isLoading = true;
    albums = await musicApiService.getArtistAlbums(apiEndPoint, artistId);
    isLoading = false;
    notifyListeners();
    return albums;
  }

  Future<Album> getAlbumForSearch(id) async {
    isLoading = true;

    final res = await getAlbumsForSearch(id);
    searchAlbum = res;

    isLoading = false;

    notifyListeners();
    return searchAlbum;
  }
}
