import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_season.dart';

class PodcastApiService {
  final String fileName = 'podcast_service.dart';
  final String className = 'PodcastApiService';

  final ErrorLoggingApiService _errorLoggingApiService =
      ErrorLoggingApiService();

  // get podcasts by category
  Future<List<PodcastCategory>> getPodcastsByCategory(
      {required int pageSize}) async {
    List<PodcastCategory> podcastCategories = [];
    try {
      // mock api call
      Response responseApi =
          await get(Uri.parse("$kinPodcastBaseUrl/mobileApp/categories"));

      if (responseApi.statusCode == 200) {
        final items = jsonDecode(responseApi.body) as List;

        podcastCategories =
            items.map((e) => PodcastCategory.fromJson(e)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getPodcastsByCategory",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return podcastCategories;
  }

  // get podcast seasons by podcast id
  Future<List<PodcastSeason>> getPodcastSeasons(
      {required int podcastId, required int pageSize}) async {
    List<PodcastSeason> podcastSeasons = [];

    try {
      Response response = await get(
        Uri.parse("$kinPodcastBaseUrl/mobileApp/seasons?podcastId=$podcastId"),
      );

      if (response.statusCode == 200) {
        final item = jsonDecode(response.body) as List;

        podcastSeasons =
            item.map((season) => PodcastSeason.fromJson(season)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getPodcastSeasons",
        errorInfo: e.toString(),
        className: className,
      );
    }

    return podcastSeasons;
  }

  // get podcast episode by season id
  Future<List<PodcastEpisode>> getPodcastEpisodes(
      {required int pageSize, required int seasonId}) async {
    List<PodcastEpisode> podcastEpisodes = [];

    try {
      Response response = await get(
        Uri.parse("$kinPodcastBaseUrl/mobileApp/episodes?seasonId=$seasonId"),
      );

      if (response.statusCode == 200) {
        final item = jsonDecode(response.body) as List;
        podcastEpisodes = item.map((e) => PodcastEpisode.fromJson(e)).toList();
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "getPodcastEpisodes",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return podcastEpisodes;
  }
}
