import 'dart:convert';
import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/network/model/companyProfile.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';
import 'package:kin_music_player_app/services/network/model/music/favorite.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';
import 'package:kin_music_player_app/services/network/model/youtube_search_result.dart';
import 'package:kin_music_player_app/services/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';

HelperUtils helper = HelperUtils();
ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();
String fileName = "api_service.dart";

// TODO:
Future incrementMusicView(musicId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = {'musicId': musicId, 'clientId': 23};
  Response response = await post(
    Uri.parse("$apiUrl/api/music/incrementView"),
    body: json.encode(data),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );
  if (response.statusCode == 201) {
    return 'Successfully Incremented';
  } else {
    return 'Already added';
  }
}

Future fetchMore(page) async {
  List<Music> musics;
  Response response =
      await get(Uri.parse("$apiUrl/api/musics/recent?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    musics = item.map((value) => Music.fromJson(value)).toList();
    return musics;
  }
}

Future fetchMorePopular(page) async {
  List<Music> musics;
  Response response =
      await get(Uri.parse("$apiUrl/api/musics/popular?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    musics = item.map((value) => Music.fromJson(value)).toList();
    return musics;
  }
}

//http://music-service-vdzflryflq-ew.a.run.app/webApp/album?page=2
// Future fetchMoreCategories(page) async {
//   List<PodCastCategory> categories;
//   Response response =
//       await get(Uri.parse("$apiUrl/api/podcast/categories?page=$page"));
//   if (response.statusCode == 200) {
//     final item = json.decode(response.body)['data'] as List;
//     categories = item.map((value) => PodCastCategory.fromJson(value)).toList();
//     return categories;
//   }
// }

Future fetchSearchedTracks(String title) async {
  Response response = await get(
      Uri.parse('https://searchservice.kinideas.com/search/track/$title'));

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var results = body['results'] as List;
      List<TrackSearch> trackSearch = [];
      results.forEach((element) {
        trackSearch.add(trackSearchFromJson(jsonEncode(element)));
      });
      return trackSearch;
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "fetchSearchedTracks",
      errorInfo: e.toString(),
    );
  }
}

Future fetchSearchedArtists(String title) async {
  Response response = await get(
      Uri.parse('https://searchservice.kinideas.com/search/artist/$title'));

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var results = body['results'] as List;
      List<ArtitstSearch> artistsearch = [];
      results.forEach((element) {
        artistsearch.add(artitstSearchFromJson(jsonEncode(element)));
      });
      return artistsearch;
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "fetchSearchedArtists",
      errorInfo: e.toString(),
    );
  }
}

Future fetchSearchedAlbums(String title) async {
  // Response response = await get(
  //     Uri.parse('https://searchservice.kinideas.com/search/album/$title'));

  // try {
  //   if (response.statusCode == 200) {
  //     var body = jsonDecode(response.body);
  //     var results = body['results'] as List;
  //     List<AlbumSearch> albumsearch = [];
  //     results.forEach((element) {
  //       albumsearch.add(albumSearchFromJson(jsonEncode(element)));
  //     });
  //     return albumsearch;
  //   }
  // } catch (e) {
  //
  // }
}

Future fetchAlbumMusics(int id) async {
  List<Music> albumMusic = [];
  try {
    String uid = await helper.getUserId();
    Response response = await get(Uri.parse(
        '$kinMusicBaseUrl/mobileApp/tracksByAlbumId?userId=$uid&albumId=$id'));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as List;
      // var results = body[0]['Tracks'] as List;

      albumMusic = body.map((track) {
        return Music.fromJson(track);
      }).toList();
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "fetchAlbumMusics",
      errorInfo: e.toString(),
    );
  }
  return albumMusic;
}

Future fetchSearchedTrackscount(String title) async {
  Response response = await get(
      Uri.parse('https://searchservice.kinideas.com/search/track/$title'));

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var results = body['count'];

      return results;
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "fetchSearchedTrackscount",
      errorInfo: e.toString(),
    );
  }
}

Future fetchMoreAlbum(page) async {
  try {
    List<Album> albums;
    Response response = await get(Uri.parse("$kinMusicBaseUrl/albums"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      item.forEach((album) {
        album['Tracks'].forEach((track) => {
              track['genre_title'] = track['genre_name'],
              track['album_cover'] = album['album_cover'] ?? "kinmusic",
              track['artist_name'] = album['artist_name'] ?? 'kin artist',
              track['lyrics_detail'] = track['lyrics_detail'] ?? "",
            });
      });
      albums = item.map((value) => Album.fromJson(value)).toList();
      return albums;
    }
  } catch (e) {}
  return [];
}

Future getArtistsforSearch(id) async {
  Response response = await get(
      Uri.parse("https://musicservice.kinideas.com/artist/?artist=$id"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    //  add info

    // add cover,artist name and genre name to single tracks
    item['single_tracks'].forEach((track) {
      track['genre_title'] = track['genre_name'];
      track['album_cover'] = track['artist_cover'];
      track['artist_name'] = item['artist_name'];
    });

    // add artist name to album
    item['Albums'].forEach((album) {
      album['artist_name'] = item['artist_name'];

      // add  cover artist name and genre to album tracks
      var allTracks = [];
      album['Tracks'].forEach((track) {
        track['genre_title'] = track['genre_name'];
        track['album_cover'] = album['album_cover'];
        track['artist_name'] = item['artist_name'];
        allTracks.add(track);
      });

      item['single_tracks'] = allTracks;
    });

    item['albums'] = item['Albums'];

    Artist artists = Artist.fromJson(item);

    return artists;
  } else {
    return [];
  }
}

Future getAlbumsForSearch(id) async {
  Response response = await get(
      Uri.parse("https://musicservice.kinideas.com/album/?album=$id"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    item['Tracks'].forEach((track) => {
          track['genre_title'] = track['genre_name'],
          track['album_cover'] = item['album_cover'] ?? "kinmusic",
          track['artist_name'] = item['artist_name'] ?? 'kin artist',
          track['lyrics_detail'] = track['lyrics_detail'] ?? "",
        });

    Album albums = Album.fromJson(item);
    return albums;
  } else {
    return [];
  }
}

Future addToPlaylist(apiEndPoint, playlistInfo) async {
  Response response = await post(
    Uri.parse("$kinMusicBaseUrl/$apiEndPoint"),
    headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    encoding: Encoding.getByName("utf-8"),
    body: json.encode(playlistInfo),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future getFavoriteMusics(apiEndPoint, id) async {
  Response response =
      await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint?user=$id"));

  try {
    List<Map<String, dynamic>> item = [];
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      if (res != null) {
        item.add(res);

        List<Favorite> musics = item.map((value) {
          return Favorite.fromJson(value);
        }).toList();

        return musics;
      } else {
        return <Favorite>[];
      }
    } else {
      return <Favorite>[];
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "getFavoriteMusics",
      errorInfo: e.toString(),
    );
    return <Favorite>[];
  }
}

Future deleteFavMusic(apiEndPoint, musicId, userId) async {
  Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body);

    List music = body['results']
        .where(
          (fav) =>
              fav['user_id'] == userId.toString() &&
              fav['track_id'] ==
                  int.parse(
                    musicId.toString(),
                  ),
        )
        .toList();

    var id = music[0]['id'];

    Response response2 =
        await delete(Uri.parse("$kinMusicBaseUrl/api/favourites/$id/"));
    if (response2.statusCode == 200) {
    } else {}
  } else {}
}

Future markusFavMusic(apiEndPoint, musicId, userId) async {
  var body = json.encode({'user_id': userId, 'track_id': musicId});
  Response response = await post(Uri.parse("$kinMusicBaseUrl$apiEndPoint"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: body);

  if (response.statusCode == 201) {
  } else {}
}

Future<int> isMusicFavorite(apiEndPoint, musicid) async {
  try {
    Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      var responses = res['Tracks'].where(
          (favmusic) => favmusic['track_id'].toString() == musicid.toString());

      return responses.length;
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

Future createPlaylist(apiEndPoint, title, id) async {
  Response response = await post(
    Uri.parse("$kinMusicBaseUrl/api" "$apiEndPoint"),
    body: json.encode(
      {"playlist_name": title.toString(), "user_id": id},
    ),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json'
    },
  );

  if (response.statusCode == 201) {
    return 'Successful';
  } else {
    return 'PlayList Title Already Exists';
  }
}

Future removeFromPlaylist(apiEndPoint, playlistId, trackId) async {
  Response response = await get(
    Uri.parse("$kinMusicBaseUrl$apiEndPoint"),
  );

  if (response.statusCode == 200) {
    var resbody = json.decode(response.body) as List;

    for (int j = 0; j < resbody[j].length; j++) {
      if (trackId == resbody[j]['playlist_id']) {
        var tracks = resbody[j]['Tracks'];

        for (int i = 0; i < resbody[j]['Tracks'].length; i++) {
          if (playlistId == tracks[i]['track_id']) {
            var playListTrackId = tracks[i]['playlisttracks_id'];

            var apiEndPoint = 'api/playlisttracks/';
            Response response = await delete(
              Uri.parse("$kinMusicBaseUrl/$apiEndPoint$playListTrackId/"),
            );

            if (response.statusCode == 204) {
              return true;
            } else {
              return false;
            }
            // removeTrackPlaylist(apiEndPoint, playListTrackId);

          }
        }
      }
    }
  }
}
//what is going on here I am not sure that this gooing well I think we need somekinda improvement

Future removeTrackPlaylist(apiEndPoint, playListTrackId) async {
  Response response = await delete(
    Uri.parse("$kinMusicBaseUrl/$apiEndPoint$playListTrackId/"),
  );

  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future removePlaylistTitle(apiEndPoint) async {
  Response response = await delete(
    Uri.parse("$kinMusicBaseUrl/api" "$apiEndPoint/"),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<List<Music>> searchMusic(apiEndPoint, searchQuery) async {
  List<Music> musics = [];
  try {
    Response response = await get(Uri.parse("$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      final results = item['results'];
      results.forEach((result) => {
            result['track_coverImage'] = result['track_coverimage'],
            result['track_audioFile'] = result['track_audiofile'],
            result['encoder_FUI'] = result['encoder_fui'],
            result['artist_name'] = result['artist_name'][0],
            result['artist_id'] = result['artist_id'][0],
          });

      results.forEach((value) => {musics.add(Music.fromJson(value))});
    }
  } catch (e) {
    errorLoggingApiService.logErrorToServer(
      fileName: fileName,
      functionName: "searchMusic",
      errorInfo: e.toString(),
    );
  }
  return musics;
}

Future<List<Artist>> searchArtist(apiEndpoint) async {
  List<Artist> artists = [];
  try {
    Response response = await get(Uri.parse("$apiEndpoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      final results = item['results'];
      results.forEach((result) =>
          {result['artist_profileImage'] = result['artist_profileimage']});
      results.forEach((value) => {artists.add(Artist.fromJson(value))});
    }
  } catch (e) {}
  return artists;
}

Future<List<Album>> searchAlbums(apiEndpoint) async {
  List<Album> albums = [];
  try {
    Response response = await get(Uri.parse("$apiEndpoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body);
      final results = item['results'];
      results.forEach((result) => {
            result['album_coverImage'] = result['album_coverimage'],
            result['artist_id'] = result['artist_id'][0],
            result['artist_name'] = result['artist_name'][0],
          });
      results.forEach((value) => {albums.add(Album.fromJson(value))});
    }
  } catch (e) {}
  return albums;
}

// Future getPodCasts(apiEndPoint) async {
//   Response response = await get(Uri.parse("$kinPodcastBaseUrl$apiEndPoint"));

//   if (response.statusCode == 200) {
//     final item = json.decode(response.body) as List;
//     List<PodCast> podCasts = item.map((value) {
//       return PodCast.fromJson(value);
//     }).toList();
//     return podCasts;
//   } else {
//     return [];
//   }
// }

// Future fetchMorePodCasts(page) async {
//   List<PodCast> podCasts;
//   Response response = await get(Uri.parse("$apiUrl/api/podcasts?page=$page"));
//   if (response.statusCode == 200) {
//     final item = json.decode(response.body)['data'] as List;
//     podCasts = item.map((value) => PodCast.fromJson(value)).toList();
//     return podCasts;
//   }
// }

// Future searchPodCast(apiEndPoint) async {
//   Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
//   if (response.statusCode == 200) {
//     final item = json.decode(response.body) as List;
//     List<dynamic> podcasts = item.map((value) {
//       return PodCast.fromJson(value);
//     }).toList();
//     return podcasts;
//   } else {
//     return [];
//   }
// }

// Future getPodCastCategories(apiEndPoint) async {
//   Response response = await get(Uri.parse("$kinPodcastBaseUrl$apiEndPoint"));

//   if (response.statusCode == 200) {
//     final item = json.decode(response.body) as List;

//     List<PodCastCategory> categories = item.map((value) {
//       return PodCastCategory.fromJson(value);
//     }).toList();
//     return categories;
//   } else {}
// }

Future<dynamic> getCompanyProfile(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    return CompanyProfile.fromJson(item);
  }
  return 'Unknown Error Occured';
}

Future<List<RadioStation>> getRadioStations(apiEndPoint) async {
  List<RadioStation> stations = [];
  Response response = await get(Uri.parse("$KinRadioUrl$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    final resbody = item['results'] as List;
    stations = resbody.map((value) {
      return RadioStation.fromJson(value);
    }).toList();
  } else {}

  return stations;
}
