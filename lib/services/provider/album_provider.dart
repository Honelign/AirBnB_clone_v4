import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

class AlbumProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _pageSize = 10;
  Album album = Album(
      id: 5,
      count: 5,
      title: 'title',
      artist: 'artist',
      description: 'description',
      cover: 'cover',
      artist_id: 'artist_id',
      price: '5',
      isPurchasedByUser: false);

  MusicApiService musicApiService = MusicApiService();

// get new albums
  Future<List<Album>> getAlbums() async {
    const String apiEndPoint = '/mobileApp/albums';
    isLoading = true;

    List<Album> albums = await musicApiService.getAlbums(apiEndPoint);
    isLoading = false;

    notifyListeners();
    return albums;
  }

  //get albums for artist
  Future<List<Album>> getArtistAlbums(String artist_id) async {
    const String apiEndPoint = '/mobileApp/albumByArtistId';
    isLoading = true;

    List<Album> albums =
        await musicApiService.getArtistAlbums(apiEndPoint, artist_id);
    isLoading = false;

    notifyListeners();
    return albums;
  }

  Future<Album> getAlbumForsearch(id) async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 1));
    //album = await getAlbumsforSearch(id);
    isLoading = false;

    notifyListeners();
    return album; //album;
  }
}
