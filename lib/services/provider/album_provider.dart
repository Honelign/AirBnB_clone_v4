import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

class AlbumProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _pageSize = 10;
  Album album = Album(
    id: 12,
    title: 'title',
    artist: 'artist',
    description: 'description',
    cover: 'cover',
    count: 0,
    artist_id: '1',
    isPurchasedByUser: false,
    price: '60',
  );

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

  Future<Album> getAlbumForsearch(id) async {
    isLoading = true;

    album = await getAlbumsforSearch(id);
    isLoading = false;

    notifyListeners();
    return album;
  }
}
