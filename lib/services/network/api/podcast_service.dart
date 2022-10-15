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
          "podcast_name": "Technology",
          "podcasts": [
            {
              'id': 1,
              'categoryId': 1,
              "title": "HypheNation: A Diaspora Life",
              "hostName": "Rebka Fisseha",
              "hostId": 1,
              "cover": "assets/images/Podcast-1.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'categoryId': 1,
              "title": "Habesha Finance",
              "hostName": "Matt G",
              "hostId": 2,
              "cover": "assets/images/Podcast-2.png",
              "description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'categoryId': 1,
              "title": "The Horn",
              "hostName": "International Crisis Group",
              "hostId": 2,
              "cover": "assets/images/Podcast-3.jpg",
              "description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //

        {
          "id": 2,
          "podcast_name": "Entertainment",
          "podcasts": [
            {
              'id': 3,
              'categoryId': 2,
              "title": "13 Months of Sunshine",
              "hostName": "TESFA",
              "hostId": 1,
              "cover": "assets/images/Podcast-4.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 1,
            },
            {
              'id': 4,
              'categoryId': 2,
              "title": "MERI Ethiopia",
              "hostName": "MERI Ethiopia",
              "hostId": 2,
              "cover": "assets/images/Podcast-8.jpg",
              "description": "",
              "numberOfEpisodes": 19,
              "numberOfSeasons": 2,
            },
            {
              'id': 5,
              'categoryId': 2,
              "title": "Rorshok Ethiopia Update",
              "hostName": "Rorshok",
              "hostId": 2,
              "cover": "assets/images/Podcast-5.png",
              "description": "",
              "numberOfEpisodes": 21,
              "numberOfSeasons": 3,
            }
          ]
        },

        //
        {
          "id": 3,
          "podcast_name": "Arts",
          "podcasts": [
            {
              'id': 1,
              'categoryId': 1,
              "title": "HypheNation: A Diaspora Life",
              "hostName": "Rebka Fisseha",
              "hostId": 1,
              "cover": "assets/images/Podcast-1.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'categoryId': 1,
              "title": "Habesha Finance",
              "hostName": "Matt G",
              "hostId": 2,
              "cover": "assets/images/Podcast-2.png",
              "description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'categoryId': 1,
              "title": "The Horn",
              "hostName": "International Crisis Group",
              "hostId": 2,
              "cover": "assets/images/Podcast-3.jpg",
              "description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //
        {
          "id": 4,
          "podcast_name": "Personal Development",
          "podcasts": [
            {
              'id': 3,
              'categoryId': 2,
              "title": "13 Months of Sunshine",
              "hostName": "TESFA",
              "hostId": 1,
              "cover": "assets/images/Podcast-4.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 1,
            },
            {
              'id': 4,
              'categoryId': 2,
              "title": "MERI Ethiopia",
              "hostName": "MERI Ethiopia",
              "hostId": 2,
              "cover": "assets/images/Podcast-8.jpg",
              "description": "",
              "numberOfEpisodes": 19,
              "numberOfSeasons": 2,
            },
            {
              'id': 5,
              'categoryId': 2,
              "title": "Rorshok Ethiopia Update",
              "hostName": "Rorshok",
              "hostId": 2,
              "cover": "assets/images/Podcast-5.png",
              "description": "",
              "numberOfEpisodes": 21,
              "numberOfSeasons": 3,
            }
          ]
        },

        //
        {
          "id": 5,
          "podcast_name": "Tv & Film",
          "podcasts": [
            {
              'id': 1,
              'categoryId': 1,
              "title": "HypheNation: A Diaspora Life",
              "hostName": "Rebka Fisseha",
              "hostId": 1,
              "cover": "assets/images/Podcast-1.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'categoryId': 1,
              "title": "Habesha Finance",
              "hostName": "Matt G",
              "hostId": 2,
              "cover": "assets/images/Podcast-2.png",
              "description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'categoryId': 1,
              "title": "The Horn",
              "hostName": "International Crisis Group",
              "hostId": 2,
              "cover": "assets/images/Podcast-3.jpg",
              "description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        //
        {
          "id": 1,
          "podcast_name": "Fun and Games",
          "podcasts": [
            {
              'id': 1,
              'categoryId': 1,
              "title": "HypheNation: A Diaspora Life",
              "hostName": "Rebka Fisseha",
              "hostId": 1,
              "cover": "assets/images/Podcast-1.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'categoryId': 1,
              "title": "Habesha Finance",
              "hostName": "Matt G",
              "hostId": 2,
              "cover": "assets/images/Podcast-2.png",
              "description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'categoryId': 1,
              "title": "The Horn",
              "hostName": "International Crisis Group",
              "hostId": 2,
              "cover": "assets/images/Podcast-3.jpg",
              "description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },

        {
          "id": 1,
          "podcast_name": "Reality",
          "podcasts": [
            {
              'id': 1,
              'categoryId': 1,
              "title": "HypheNation: A Diaspora Life",
              "hostName": "Rebka Fisseha",
              "hostId": 1,
              "cover": "assets/images/Podcast-1.jpg",
              "description": "",
              "numberOfEpisodes": 8,
              "numberOfSeasons": 2,
            },
            {
              'id': 2,
              'categoryId': 1,
              "title": "Habesha Finance",
              "hostName": "Matt G",
              "hostId": 2,
              "cover": "assets/images/Podcast-2.png",
              "description": "desc",
              "numberOfEpisodes": 18,
              "numberOfSeasons": 3,
            },
            {
              'id': 3,
              'categoryId': 1,
              "title": "The Horn",
              "hostName": "International Crisis Group",
              "hostId": 2,
              "cover": "assets/images/Podcast-3.jpg",
              "description": "desc",
              "numberOfEpisodes": 33,
              "numberOfSeasons": 4,
            }
          ]
        },
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
          "seasonNumber": 1,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 2,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "seasonNumber": 3,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 4,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 1,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 2,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "seasonNumber": 3,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 4,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 1,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 2,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 3,
          "seasonNumber": 3,
          "numberOfEpisodes": 25,
          "cover": "assets/images/Podcast-1.jpg",
        },
        {
          "id": 1,
          "seasonNumber": 4,
          "numberOfEpisodes": 12,
          "cover": "assets/images/Podcast-1.jpg",
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
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
        },
        {
          "id": 1,
          "episode_number": "Sew ena Aden",
          "hostName": "Abel Alem",
          "hostId": 1,
          "categoryId": 1,
          "audio": "audio",
          "cover": "assets/images/Podcast-2.png",
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
