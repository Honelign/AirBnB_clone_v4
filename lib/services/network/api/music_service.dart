import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

class MusicApiService {
  // get new tracks
  Future getMusic(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Music> music = item.map((value) => Music.fromJson(value)).toList();

        return music;
      } else {}
    } catch (e) {
      print("@music_service getMusic $e");
    }
    return [];
  }

  // albums
  Future getAlbums(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Album> albums = item.map((value) {
          return Album.fromJson(value);
        }).toList();

        return albums;
      } else {}
    } catch (e) {
      print("@music_service -> getAlbums error - $e");
    }
    return [];
  }

  // get artists
  Future getArtists(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl$apiEndPoint"));

      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        item.forEach((artist) {
          artist['Albums'].forEach((album) {
            List allAlbums = artist['Tracks']
                .where((track) =>
                    track['album_id'].toString() == album['id'].toString())
                .toList();

            album['Tracks'] = allAlbums;
          });
        });

        List<Artist> artists = item.map((value) {
          return Artist.fromJson(value);
        }).toList();

        return artists;
      }
    } catch (e) {
      print("@music_service -> getArtists error - $e");
    }
    return [];
  }

  // ignore: slash_for_doc_comments
  /**
   * ==================================
   * GENRE METHODS
   * ==================================
   */

  // get list of all available genres
  Future<List<Genre>> getGenres(apiEndPoint) async {
    try {
      Response response = await get(Uri.parse("$kinMusicBaseUrl/$apiEndPoint"));
      if (response.statusCode == 200) {
        final item = json.decode(response.body) as List;

        List<Genre> genres = item.map((value) {
          return Genre.fromJson(value);
        }).toList();
        return genres;
      }
    } catch (e) {
      print("@music_service -> getGenres error $e");
    }
    return [];
  }

  // get list of all available genres
  Future<List<Music>> getMusicByGenreID({
    required String apiEndPoint,
    required String genreId,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      List responseMock = [
        {
          "id": 2,
          "track_name": "O - Africa",
          "track_file":
              "Media_Files/Track_Files/1: Tewodros Kassahun/8: Tiqur Sew/O_-_Africa_Teddy_Afro_-_O-Africa.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/O_-_Africa_tikursewalbumcover.jpeg",
          "artist_id": 1,
          "album_id": 8,
          "genre_id": 2,
          "track_price": 10,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Tewodros Kassahun",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 10,
          "track_name": "Anchin New",
          "track_file":
              "Media_Files/Track_Files/2: Rophnan Nuri/10: Reflection/Anchin_New_Anchin_New.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Anchin_New_reflectionalbumcover.jpeg",
          "artist_id": 2,
          "album_id": 10,
          "genre_id": 2,
          "track_price": 10,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Rophnan Nuri",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 18,
          "track_name": "Beketemaw",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/12: Etemete/Beketemaw_Awtar_TV_-_Rahel_Getu_-_Beketemaw_-_.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Beketemaw_etemetealbumcover.jpeg",
          "artist_id": 3,
          "album_id": 12,
          "genre_id": 2,
          "track_price": 10,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 26,
          "track_name": "Akolamiche",
          "track_file":
              "Media_Files/Track_Files/4: Lij Michael/14: Atgebam Alugn/Akolamiche_AKOLAMICHE.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Akolamiche_ategebamalugncoverimage.jpeg",
          "artist_id": 4,
          "album_id": 14,
          "genre_id": 2,
          "track_price": 10,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Lij Michael",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 34,
          "track_name": "Asmarino",
          "track_file":
              "Media_Files/Track_Files/6: Dawit Tsige/16: Yene Zema/Asmarino_Dawit_Tsige___Asmarino.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Asmarino_yenezemaalbumcover.jpeg",
          "artist_id": 6,
          "album_id": 16,
          "genre_id": 2,
          "track_price": 10,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Dawit Tsige",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 42,
          "track_name": "Esubalew Yetayew - Chaw Chaw",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/3: Singles/Esubalew_Yetayew_-_Chaw_Chaw_Esubalew_Yetayew_-.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Esubalew_Yetayew_-_Chaw_Chaw_esube-chawchaew.jpg",
          "artist_id": 3,
          "album_id": 3,
          "genre_id": 2,
          "track_price": 5,
          "genre_title": "Electronic Dance Music",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 2, "genre_title": "Electronic Dance Music"},
          "Lyrics": ""
        },
        {
          "id": 1,
          "track_name": "Des Yemil Sikay",
          "track_file":
              "Media_Files/Track_Files/1: Tewodros Kassahun/8: Tiqur Sew/Des_Yemil_Sikay_Teddy_Afro_-_Des_Yemil.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Des_Yemil_Sikay_tikursewalbumcover.jpeg",
          "artist_id": 1,
          "album_id": 8,
          "genre_id": 1,
          "track_price": 10,
          "genre_title": "Country",
          "artist_name": "Tewodros Kassahun",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 9,
          "track_name": "Ade Dorze",
          "track_file":
              "Media_Files/Track_Files/2: Rophnan Nuri/10: Reflection/Ade_Dorze_Ade_Dorze.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Ade_Dorze_reflectionalbumcover.jpeg",
          "artist_id": 2,
          "album_id": 10,
          "genre_id": 1,
          "track_price": 10,
          "genre_title": "Country",
          "artist_name": "Rophnan Nuri",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 17,
          "track_name": "Astaraki",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/12: Etemete/Astaraki_Awtar_TV_-_Rahel_Getu_-_Astaraki__-_N.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Astaraki_etemetealbumcover.jpeg",
          "artist_id": 3,
          "album_id": 12,
          "genre_id": 1,
          "track_price": 10,
          "genre_title": "Country",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 25,
          "track_name": "Addis Ababa",
          "track_file":
              "Media_Files/Track_Files/4: Lij Michael/14: Atgebam Alugn/Addis_Ababa_ADDIS_ABABA.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Addis_Ababa_ategebamalugncoverimage.jpeg",
          "artist_id": 4,
          "album_id": 14,
          "genre_id": 1,
          "track_price": 10,
          "genre_title": "Country",
          "artist_name": "Lij Michael",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 33,
          "track_name": "Aschilosh",
          "track_file":
              "Media_Files/Track_Files/6: Dawit Tsige/16: Yene Zema/Aschilosh_Dawit_Tsige___Aschelosh.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Aschilosh_yenezemaalbumcover.jpeg",
          "artist_id": 6,
          "album_id": 16,
          "genre_id": 1,
          "track_price": 10,
          "genre_title": "Country",
          "artist_name": "Dawit Tsige",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 41,
          "track_name": "Betty Sher - Gen",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/3: Singles/Betty_Sher_-_Gen_Betty_Sher_-_Gen_-_Ethiopian_M.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Betty_Sher_-_Gen_betty-sher-gin.jpg",
          "artist_id": 3,
          "album_id": 3,
          "genre_id": 1,
          "track_price": 5,
          "genre_title": "Country",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 1, "genre_title": "Country"},
          "Lyrics": ""
        },
        {
          "id": 3,
          "track_name": "Sitihed",
          "track_file":
              "Media_Files/Track_Files/1: Tewodros Kassahun/8: Tiqur Sew/Sitihed_Teddy_Afro_-_Sitihed.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Sitihed_tikursewalbumcover.jpeg",
          "artist_id": 1,
          "album_id": 8,
          "genre_id": 3,
          "track_price": 10,
          "genre_title": "Love",
          "artist_name": "Tewodros Kassahun",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        },
        {
          "id": 11,
          "track_name": "Bye Bye",
          "track_file":
              "Media_Files/Track_Files/2: Rophnan Nuri/10: Reflection/Bye_Bye_Bye_Bye.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Bye_Bye_reflectionalbumcover.jpeg",
          "artist_id": 2,
          "album_id": 10,
          "genre_id": 3,
          "track_price": 10,
          "genre_title": "Love",
          "artist_name": "Rophnan Nuri",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        },
        {
          "id": 19,
          "track_name": "Etemete",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/12: Etemete/Etemete_Awtar_TV_-_Rahel_Getu_-_Etemete_-_New_.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Etemete_etemetealbumcover.jpeg",
          "artist_id": 3,
          "album_id": 12,
          "genre_id": 3,
          "track_price": 10,
          "genre_title": "Love",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        },
        {
          "id": 27,
          "track_name": "Alachu Wey",
          "track_file":
              "Media_Files/Track_Files/4: Lij Michael/14: Atgebam Alugn/Alachu_Wey_ALACHU_WEY.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Alachu_Wey_ategebamalugncoverimage.jpeg",
          "artist_id": 4,
          "album_id": 14,
          "genre_id": 3,
          "track_price": 10,
          "genre_title": "Love",
          "artist_name": "Lij Michael",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        },
        {
          "id": 35,
          "track_name": "Balageru #4",
          "track_file":
              "Media_Files/Track_Files/6: Dawit Tsige/16: Yene Zema/Balageru_4_Dawit_Tsige___Balageru_4.mp3",
          "track_cover":
              "Media_Files/Track_Cover_Images/Balageru_4_yenezemaalbumcover.jpeg",
          "artist_id": 6,
          "album_id": 16,
          "genre_id": 3,
          "track_price": 10,
          "genre_title": "Love",
          "artist_name": "Dawit Tsige",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        },
        {
          "id": 43,
          "track_name": "Lij Mic",
          "track_file":
              "Media_Files/Track_Files/3: Rahel Getu/3: Singles/Lij_Mic_Ethiopian_music-_Lij_mic_-_Addis_Ababa_.mp3",
          "track_cover": "Media_Files/Track_Cover_Images/Lij_Mic_lijmic.jpg",
          "artist_id": 3,
          "album_id": 3,
          "genre_id": 3,
          "track_price": 5,
          "genre_title": "Love",
          "artist_name": "Rahel Getu",
          "Genre": {"id": 3, "genre_title": "Love"},
          "Lyrics": ""
        }
      ];

      List<Music> tracksUnderGenre = responseMock.map((track) {
        return Music.fromJson(track);
      }).toList();

      return tracksUnderGenre;
    } catch (e) {
      print("@music_service -> getMusicByGenreID error $e");
      return [];
    }
  }

  Future addPopularCount(
      {required String track_id, required String user_id}) async {
    var data = {"user_id": user_id, "track_id": track_id};
    Response response = await post(
      Uri.parse("${kAnalyticsBaseUrl}/view_count"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: json.encode(data),
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
}
