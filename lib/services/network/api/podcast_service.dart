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

      await Future.delayed(const Duration(seconds: 2));
      List<Map<String, dynamic>> response = [
        {
          "id": 1,
          "category_name": "Technology",
          "podcasts": [
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //

        {
          "id": 2,
          "category_name": "Entertainment",
          "podcasts": [
            {
              'id': 3,
              'category': 2,
              "podcast_name": "13 Months of Sunshine",
              "host_name": "TESFA",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-4.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 1,
            },
            {
              'id': 4,
              'category': 2,
              "podcast_name": "MERI Ethiopia",
              "host_name": "MERI Ethiopia",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-8.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 19,
              "numberOfSeasons": 2,
            },
            {
              'id': 5,
              'category': 2,
              "podcast_name": "Rorshok Ethiopia Update",
              "host_name": "Rorshok",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-5.png",
              "podcast_description": "",
              "numberOfEpisodes": 21,
              "numberOfSeasons": 3,
            }
          ]
        },

        //
        {
          "id": 3,
          "category_name": "Arts",
          "podcasts": [
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //
        {
          "id": 4,
          "category_name": "Personal Development",
          "podcasts": [
            {
              'id': 3,
              'category': 2,
              "podcast_name": "13 Months of Sunshine",
              "host_name": "TESFA",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-4.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 1,
            },
            {
              'id': 4,
              'category': 2,
              "podcast_name": "MERI Ethiopia",
              "host_name": "MERI Ethiopia",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-8.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 19,
              "numberOfSeasons": 2,
            },
            {
              'id': 5,
              'category': 2,
              "podcast_name": "Rorshok Ethiopia Update",
              "host_name": "Rorshok",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-5.png",
              "podcast_description": "",
              "numberOfEpisodes": 21,
              "numberOfSeasons": 3,
            }
          ]
        },

        //
        {
          "id": 5,
          "category_name": "Tv & Film",
          "podcasts": [
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            },
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            },
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //
        {
          "id": 1,
          "category_name": "Fun and Games",
          "podcasts": [
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        {
          "id": 1,
          "category_name": "Reality",
          "podcasts": [
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            },
            {
              'id': 1,
              'category': 1,
              "podcast_name": "HypheNation: A Diaspora Life",
              "host_name": "Rebka Fisseha",
              "host": 1,
              "podcast_coverImage": "assets/images/Podcast-1.jpg",
              "podcast_description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'category': 1,
              "podcast_name": "Habesha Finance",
              "host_name": "Matt G",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-2.png",
              "podcast_description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'category': 1,
              "podcast_name": "The Horn",
              "host_name": "International Crisis Group",
              "host": 2,
              "podcast_coverImage": "assets/images/Podcast-3.jpg",
              "podcast_description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        }
      ];

      podcastCategories = response
          .map(
            (podcastCategory) => PodcastCategory.fromJson(podcastCategory),
          )
          .toList();
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
      await Future.delayed(const Duration(seconds: 2));
      List<Map<String, dynamic>> response = [
        {
          "id": 1,
          "season_name": 1,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 2,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "season_name": 3,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 4,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 1,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 2,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "season_name": 3,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 4,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 1,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 2,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "season_name": 3,
          "numberOfEpisodes": 25,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "season_name": 4,
          "numberOfEpisodes": 12,
          "season_coverImage": "assets/images/Podcast-1.jpg",
        },
      ];

      podcastSeasons = response
          .map(
            (e) => PodcastSeason.fromJson(e),
          )
          .toList();
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
      await Future.delayed(const Duration(seconds: 2));
      List<Map<String, dynamic>> response = [
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "episode_coverImage": "assets/images/Podcast-2.png",
          "episode_audioFile": "episode_audioFile",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_name": "Sew ena Aden",
          "host_name": "Abel Alem",
          "host": 1,
          "category": 1,
          "episode_audioFile": "episode_audioFile",
          "episode_coverImage": "assets/images/Podcast-2.png",
        }
      ];

      podcastEpisodes =
          response.map((e) => PodcastEpisode.fromJson(e)).toList();
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
