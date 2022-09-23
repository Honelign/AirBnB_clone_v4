import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/model/album_for_search.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';
import 'package:kin_music_player_app/services/network/model/youtube_search_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/companyProfile.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';

import '../../constants.dart';

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
}

//what is going on here I am not sure that this gooing well I think we need somekinda improvement

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




