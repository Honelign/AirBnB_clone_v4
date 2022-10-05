import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';

class ArtistProvider extends ChangeNotifier {
  bool isLoading = false;

  MusicApiService musicApiService = MusicApiService();

  Future<List<Artist>> getArtist({required int pageSize}) async {
    const String apiEndPoint = '/mobileApp/artists';
    isLoading = true;
    List<Artist> artists = await musicApiService.getArtists(
        apiEndPoint: apiEndPoint, pageSize: pageSize);

    isLoading = false;
    notifyListeners();
    return artists;
  }
}
