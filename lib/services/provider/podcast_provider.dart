import 'package:flutter/cupertino.dart';
import 'package:kin_music_player_app/services/network/api/podcast_service.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_season.dart';

class PodcastProvider extends ChangeNotifier {
  bool isLoading = false;
  List<PodcastCategory> podcastCategories = [];
  List<PodcastSeason> podcastSeason = [];
  List<PodcastEpisode> podcastEpisodes = [];
  PodcastApiService _podcastApiService = PodcastApiService();

  // get podcasts by category
  Future<List<PodcastCategory>> getPodcastsByCategory(
      {required int pageSize}) async {
    isLoading = true;
    podcastCategories =
        await _podcastApiService.getPodcastsByCategory(pageSize: pageSize);
    isLoading = false;
    notifyListeners();
    return podcastCategories;
  }

  // get podcast seasons by podcast id
  Future<List<PodcastSeason>> getPodcastSeasons(
      {required int podcastId, required int pageSize}) async {
    isLoading = true;
    podcastSeason = await _podcastApiService.getPodcastSeasons(
        podcastId: podcastId, pageSize: pageSize);
    isLoading = false;
    notifyListeners();
    return podcastSeason;
  }

  // get podcast episode by season id
  Future<List<PodcastEpisode>> getPodcastEpisodes(
      {required int pageSize, required int seasonId}) async {
    isLoading = true;
    podcastEpisodes = await _podcastApiService.getPodcastEpisodes(
        pageSize: pageSize, seasonId: seasonId);
    isLoading = false;
    notifyListeners();
    return podcastEpisodes;
  }
}
