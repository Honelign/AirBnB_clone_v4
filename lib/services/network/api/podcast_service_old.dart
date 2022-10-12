import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcast_category.dart';

class PodcastApiService {
  Future getPodCasts(apiEndPoint) async {
    Response response = await get(Uri.parse("$kinPodcastBaseUrl$apiEndPoint"));

    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<PodCast> podCasts = item.map((value) {
        return PodCast.fromJson(value);
      }).toList();
      return podCasts;
    } else {
      return [];
    }
  }

  Future fetchMorePodCasts(page) async {
    List<PodCast> podCasts;
    Response response = await get(Uri.parse("$apiUrl/api/podcasts?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      podCasts = item.map((value) => PodCast.fromJson(value)).toList();
      return podCasts;
    }
  }

  Future searchPodCast(apiEndPoint) async {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<dynamic> podcasts = item.map((value) {
        return PodCast.fromJson(value);
      }).toList();
      return podcasts;
    } else {
      return [];
    }
  }

  Future getPodCastCategories(apiEndPoint) async {
    Response response = await get(Uri.parse("$kinPodcastBaseUrl$apiEndPoint"));

    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;

      List<PodCastCategory> categories = item.map((value) {
        return PodCastCategory.fromJson(value);
      }).toList();
      return categories;
    } else {}
  }
}
