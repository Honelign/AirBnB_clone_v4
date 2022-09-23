// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/screens/podcast/podcast.dart';
import 'package:kin_music_player_app/services/network/model/album_for_search.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/network/model/playlist.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';
import 'package:kin_music_player_app/services/network/model/podcastSeasons.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';
import 'package:kin_music_player_app/services/network/model/youtube_search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/companyProfile.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../constants.dart';
import 'model/user.dart';

Future<String> fetchUserPrivilege(
    {required String uid, required String apiEndPoint}) async {
  try {
    // make api call
    Response response =
        await get(Uri.parse("$kinProfileBaseUrl$apiEndPoint/$uid"));

    // check response code
    if (response.statusCode == 200) {
      var item = jsonDecode(response.body);

      return item['privilege'].toString();
    }

    // return value
  } catch (e) {
    print("@@@ api_service fetchUserPrivilege  $e");
  }
  return "-1";
}

// Email and Password Register
Future<String> createAccount(user) async {
  try {
    // try firebase auth call
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: user.email.toString(),
      password: user.password.toString(),
    );
    var currentUser = await FirebaseAuth.instance.currentUser!;
    // update user name
    currentUser.updateDisplayName(
      user.name.toString(),
    );

    // save some info to cache -> shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', currentUser.uid);
    await prefs.setString(
        'name${currentUser.uid}', currentUser.displayName ?? "");
    await prefs.setString('email${currentUser.uid}', currentUser.email ?? "");

    return "Successfully Registered";
  } on FirebaseAuthException catch (e) {
    if (e.code == "email-already-in-use" || e.code == "email-already-exists") {
      return "Email already registered";
    } else if (e.code == "invalid-display-name") {
      return "Invalid Full Name";
    } else if (e.code == "invalid-email") {
      return "Email in use";
    } else if (e.code == "invalid-password" || e.code == "weak-password") {
      return "Weak Password";
    } else {
      print(
        "@@api_service + " + e.toString(),
      );
      return "Something went wrong";
    }
  } catch (e) {
    return 'Unknown Error Occurred';
  }
}

// Email and Password Register
Future logIn(email, password) async {
  try {
    // connect with firebase
    var possibleUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (possibleUser.user != null) {
      var currentUser = possibleUser.user;

      // cache user info
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', currentUser!.uid);
      await prefs.setString(
          'name${currentUser.uid}', currentUser.displayName ?? "");
      await prefs.setString('email${currentUser.uid}', currentUser.email ?? "");
    }

    return "Successfully Logged In";
  } on FirebaseAuthException catch (e) {
    if (e.code == "wrong-password" || e.code == "user-not-found") {
      return "Invalid Credentials";
    } else if (e.code == "invalid-email") {
      print("@@api_service + " + e.code);
      return "Something Went Wrong";
    }
  } catch (e) {
    print("@@api_service" + e.toString());
    print("@@api_service + " + e.toString());
    return "Something Went Wrong";
  }
}

// TODO:Implement
Future loginWithFacebook(apiEndPoint) async {}

// Google Sign in Function
Future loginWithGoogle() async {
  try {
    final googleSignIn = GoogleSignIn();

    GoogleSignInAccount? _user;

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;
    _user = googleUser;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var fbUser = await FirebaseAuth.instance.signInWithCredential(credential);
    var currentUser = fbUser.user!;
    // cache user info
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', currentUser.uid);
    await prefs.setString(
        'name${currentUser.uid}', currentUser.displayName ?? "");
    await prefs.setString('email${currentUser.uid}', currentUser.email ?? "");

    return "Successfully Logged In";
  } catch (e) {
    print("@api_service -> loginWithGoogle error - " + e.toString());
    return e.toString();
  }
}

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

Future fetchMoreCategories(page) async {
  List<PodCastCategory> categories;
  Response response =
      await get(Uri.parse("$apiUrl/api/podcast/categories?page=$page"));
  if (response.statusCode == 200) {
    final item = json.decode(response.body)['data'] as List;
    categories = item.map((value) => PodCastCategory.fromJson(value)).toList();
    return categories;
  }
}

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
    print("@api_service -> fetchSearchedTracks error -> " + e.toString());
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
    print("@api_service -> fetchSearchedArtists error -> " + e.toString());
  }
}

Future fetchSearchedAlbums(String title) async {
  Response response = await get(
      Uri.parse('https://searchservice.kinideas.com/search/album/$title'));

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var results = body['results'] as List;
      List<AlbumSearch> albumsearch = [];
      results.forEach((element) {
        albumsearch.add(albumSearchFromJson(jsonEncode(element)));
      });
      return albumsearch;
    }
  } catch (e) {
    print("@api_service -> fetchSearchedAlbums error - " + e.toString());
  }
}

Future fetchAlbumMusics(int id) async {
  Response response = await get(Uri.parse(
      'https://music-service-v1-vdzflryflq-ew.a.run.app/mobile_app/albums'));

  try {
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var results = body[0]['Tracks'] as List;
      List<Music> albumMusic = [];

      albumMusic = results.map((track) {
        return Music.fromJson(track);
      }).toList();
      return albumMusic;
    }
  } catch (e) {
    print("@api_service -> fetchSearchedAlbums error - " + e.toString());
  }
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
    print("@api_service -> fetchSearchedTrackscount error - " + e.toString());
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

Future getAlbumsforSearch(id) async {
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

Future getPlayLists(apiEndPoint) async {
  Response response = await get(Uri.parse("$kinMusicBaseUrl/" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    item.forEach((playlistTitle) {
      List playlistList = [];
      playlistTitle['playlists'] = [];
      playlistTitle['Tracks'].forEach((track) {
        Map<String, dynamic> playlistInfo = {};

        playlistInfo['playlist_id'] = playlistTitle['playlist_id'];
        playlistInfo['playlist_music'] = track;
        playlistList.add(playlistInfo);
      });
      playlistTitle['playlists'] = playlistList;
      playlistTitle.remove("Tracks");
    });

    List<PlaylistTitle> playlists = item.map((value) {
      return PlaylistTitle.fromJson(value);
    }).toList();

    return playlists;
  } else {}

  // Response response = await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint"));

  // if (response.statusCode == 200) {
  //   final item = json.decode(response.body) as List;
  //   item.forEach((musics) {
  //     musics['Tracks'].forEach((tracks) {
  //       tracks['lyrics_detail'] = tracks['genre_title'];
  //       tracks['lyrics_id'] = tracks['genre_title'];
  //     });
  //   });
  //   List<PlaylistTitle> playlists = item.map((value) {
  //     return PlaylistTitle.fromJson(value);
  //   }).toList();

  //   return playlists;
  // } else {}
}

Future getPlayListTitles(apiEndPoint) async {
  Response response = await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<PlayListTitles> playlistTitles = item.map((value) {
      return PlayListTitles.fromJson(value);
    }).toList();
    return playlistTitles;
  } else {}
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
    print("@api_service--getFavMusic" + e.toString());
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

Future searchMusic(apiEndPoint, searchQuery) async {
  // // Response response =
  // //     await get(Uri.parse("$kinMusicBaseUrl/api" "$apiEndPoint"));
  // // if (response.statusCode == 200) {
  // //   final item = json.decode(response.body) as List;
  // //   List<dynamic> musics = item.map((value) {
  // //     return Music.fromJson(value);
  // //   }).toList();
  // //   return musics;
  // // } else {
  // //   return [];
  // // }
  // try {
  //   // Response response = await get(Uri.parse("$kinSearchBaseUrl$apiEndPoint"));

  //   // // response
  //   // if (response.statusCode == 200) {
  //   //   final item = json.decode(response.body);

  //   // if (item['count'] > 0) {
  //   // final results = item['results'];
  //   // results.forEach((result) => {
  //   //       result['track_id'] = result['id'],
  //   //       // track name
  //   //       // track file
  //   //       result['album_cover'] =
  //   //           "https://storage.googleapis.com/kin-project-352614-storage/Media_Files/Albums_Cover_Images/2:%20Rophnan%20Nuri/Sidist-VI/Sidist-VI_-_sidistvialbumcover.jpeg",
  //   //       result['artist_name'] = "Rophnan Nuri",
  //   //       result['lyric_detail'] = "Lyric",
  //   //       result['genre_title'] = "Desc",
  //   //     });
  //   List results = [
  //     {
  //       "track_id": 140,
  //       "track_name": "TAMOLISHAL",
  //       "track_file":
  //           "Media_Files/Albums_Cover_Images/1:%20Tewodros%20Kassahun/TikurSew/TikurSew_-_tikursewalbumcover.jpeg",
  //       "album_cover":
  //           "Media_Files/Albums_Cover_Images/1:%20Tewodros%20Kassahun/Ethiopia/Ethiopia_-_ethiopiaabumcover.jpeg",
  //       "artist_name": "Tewodros Kassahun",
  //       "lyrics_detail": "Detail",
  //       "genre_title": "Desc"
  //     }
  //   ];

  //   // List<Music> musics = results.map((value) {
  //   //   return Music.fromJson(value);
  //   // }).toList();

  //   Music music = Music.fromJson(results[0]);

  //   //
  //   // } else {
  //   //
  //   // }
  //   // } else {
  //   //
  //   // }
  //   return [music];
  // } catch (e) {
  //
  // }

  // youtube search
  try {
    String url =
        "https://www.googleapis.com/youtube/v3/search?key=${youtubeDataApiKey}&type=video&part=snippet&maxResults=12&q=$searchQuery";

    Response youtubeResponse = await get(Uri.parse(url));
    if (youtubeResponse.statusCode == 200) {
      final items = jsonDecode(youtubeResponse.body)['items'] as List;
      List results = [];

      int index = 8;

      if (items.length < 8) {
        index = items.length;
      }

      for (var i = 0; i <= index; i++) {
        String videoId = items[i]['id']['videoId'];

        results.add({
          "video_id": videoId,
          "video_url": "https://www.youtube.com/watch?v=${videoId}",
          "video_title": items[i]['snippet']['title'],
          "video_cover": items[i]['snippet']['thumbnails']['medium']['url'],
          "video_channel": items[i]['snippet']['channelTitle'],
          "video_description": items[i]['snippet']['description'],
        });
      }

      List<YoutubeSearchResult> youTubeResults = results
          .map((result) => YoutubeSearchResult.fromJson(result))
          .toList();

      return youTubeResults;
    }
  } catch (e) {
    print("@api_service -> searchMusic error - ${e}");
  }

  return [];
}

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

Future<dynamic> getCompanyProfile(apiEndPoint) async {
  Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body);

    return CompanyProfile.fromJson(item);
  }
  return 'Unknown Error Occured';
}

Future<List<RadioStation>> getRadioStations(apiEndPoint) async {
  Response response = await get(Uri.parse("$kinRadioBaseUrl/$apiEndPoint"));

  if (response.statusCode == 200) {
    final item = json.decode(response.body) as List;
    List<RadioStation> stations = item.map((value) {
      return RadioStation.fromJson(value);
    }).toList();

    return stations;
  } else {}
  return [];
}

// Gift methods




