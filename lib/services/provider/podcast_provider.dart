import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/podcast_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';

class PodCastProvider extends ChangeNotifier {
  bool isLoading = false;
  List<dynamic> searchedPodCasts = [];
  PodcastApiService podcastApiService = PodcastApiService();
  Future<List<PodCast>> getPodCast() async {
    String apiEndPoint = '/play_seasons/';
    isLoading = true;
    List<PodCast> podCasts = await podcastApiService.getPodCasts(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return podCasts;
  }

  Future<List<PodCast>> getPopularPodCast() async {
    String apiEndPoint = '/play_seasons/';
    isLoading = true;
    List<PodCast> podCasts = await podcastApiService.getPodCasts(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return podCasts;
  }

  Future<List<PodCastCategory>> getPodCastCategory() async {
    String apiEndPoint = '/play_categories/';
    isLoading = true;
    List<PodCastCategory> categories =
        await podcastApiService.getPodCastCategories(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return categories;
  }

  Future searchedPodCast(keyword) async {
    String apiEndPoint = '/podcast/search/$keyword';
    isLoading = true;
    searchedPodCasts = await podcastApiService.searchPodCast(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return searchedPodCasts;
  }
}
