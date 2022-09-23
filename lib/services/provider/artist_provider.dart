import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';

import '../network/api_service.dart';

class ArtistProvider extends ChangeNotifier {
  bool isLoading = false;
  Artist artist = Artist(id: 12, name: 'name', cover: '', musics: []);
  MusicApiService musicApiService = MusicApiService();

  Future<List<Artist>> getArtist() async {
    const String apiEndPoint = '/mobileApp/artists';
    isLoading = true;
    List<Artist> artists = await musicApiService.getArtists(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return artists;
  }

  Future<Artist> getArtistForSearch(id) async {
    isLoading = true;
    artist = await getArtistsforSearch(id);

    isLoading = false;
    notifyListeners();
    return artist;
  }
}
