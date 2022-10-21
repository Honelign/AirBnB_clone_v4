import 'dart:async';
//import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/album_card_search.dart';
import 'package:kin_music_player_app/components/artist_card_search.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_card_search.dart';
import 'package:kin_music_player_app/components/search/youtube_search_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_card.dart';
import 'package:kin_music_player_app/screens/home/components/album_search_result.dart';
import 'package:kin_music_player_app/screens/home/components/artist_search_result.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../../services/network/model/music/album.dart';
import '../../../services/network/model/music/artist.dart';

class HomeSearchScreen extends StatefulWidget {
  static String routeName = 'homeSearchScreen';

  const HomeSearchScreen({Key? key}) : super(key: key);

  @override
  State<HomeSearchScreen> createState() => _HomeSearchScreenState();
}

class _HomeSearchScreenState extends State<HomeSearchScreen> {
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MusicProvider>(context, listen: false);
    provider.searchedMusics.clear();

    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          provider.searchedMusic(
            searchController.text,
          );

          provider.searchedArtists(searchController.text);
          provider.searchedAlbums(searchController.text);
        });
      } else {
        provider.searchedMusics.clear();
      }
    });
  }

  String currentSearchType = 'track';
  var possibleSearchTypes = ['track', 'artist', 'album'];
  String title = 'track';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);

    List<Music> musics = [];
    List<Artist> artists = [];
    List<Album> albums = [];
    // if (provider.searchedMusics.isNotEmpty) {
    //   for (int i = 0; i < provider.searchedMusics.length; i++) {
    //     searchedMusicsList.add(provider.searchedMusics[i]);
    //   }
    // }
    if (provider.searchedMusics.isNotEmpty) {
      for (int i = 0; i < provider.searchedMusics.length; i++) {
        musics.add(provider.searchedMusics[i]);
      }
    }
    if (provider.artists.isNotEmpty) {
      for (int i = 0; i < provider.artists.length; i++) {
        artists.add(provider.artists[i]);
      }
    }
    if (provider.albums.isNotEmpty) {
      for (int i = 0; i < provider.albums.length; i++) {
        albums.add(provider.albums[i]);
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            'assets/images/logo.png',
          ),
          fit: BoxFit.contain,
        )),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFF052C54),
                    Color(0xFFD9D9D9).withOpacity(0.7)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(10),
                  ),
                  SafeArea(
                    child: Row(
                      children: [
                        // BackButton(
                        //   color: Colors.white,
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        // ),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Expanded(
                            child: _buildSearchBar(
                                context, 'Searching ${title}s...', provider)),

                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.only(
                        //         topRight: Radius.circular(20),
                        //         bottomRight: Radius.circular(20)),
                        //     color: Colors.white.withOpacity(0.1),
                        //   ),
                        //   width: MediaQuery.of(context).size.width * 0.20,
                        //   child: Center(
                        //     child: DropdownButton(
                        //       underline: Container(),
                        //       value: currentSearchType,
                        //       style: TextStyle(
                        //           color: Colors.red,
                        //           overflow: TextOverflow.ellipsis),
                        //       isExpanded: true,
                        //       icon: const Icon(
                        //         Icons.keyboard_arrow_down,
                        //         color: Colors.white,
                        //       ),
                        //       // Array list of items
                        //       items: possibleSearchTypes.map((String items) {
                        //         return DropdownMenuItem(
                        //           value: items,
                        //           child: Text(
                        //             items,
                        //             style: TextStyle(color: kGrey),
                        //           ),
                        //         );
                        //       }).toList(),
                        //       onChanged: (String? newValue) {
                        //         setState(() {
                        //           currentSearchType = newValue!;
                        //           title = newValue;
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: getProportionateScreenWidth(15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      child: Expanded(
                    child: provider.isLoading == true
                        ? KinProgressIndicator()
                        : provider.searchedMusics.isEmpty
                            ? const Center(
                                child: Text(
                                'No dataa',
                                style: TextStyle(color: kGrey),
                              ))
                            // : ListView.builder(
                            //     itemCount:
                            //         provider.searchedMusics.length,
                            //     itemBuilder: (context, index) {
                            //       // return MusicListCard(
                            //       //   music: provider.searchedMusics[index],
                            //       //   musics: searchedMusicsList,
                            //       //   musicIndex: index,
                            //       // );
                            //       return YoutubeSearchCard(
                            //         result:
                            //             searchedMusicsList[index],
                            //       );
                            //     },
                            //   )
                            : Container(
                                height: 700,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: artists.length > 0 ? 150 : 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Artists',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Container(
                                              height: 130,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: artists.length,
                                                itemBuilder: ((context, index) {
                                                  // TODO: Replace Artist and Album ID
                                                  return ArtistCardSearch(
                                                      artist: artists[index],
                                                      index: index);
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: albums.length > 0 ? 180 : 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Albums',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Container(
                                              height: 150,
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: albums.length,
                                                itemBuilder: ((context, index) {
                                                  // TODO: Replace Artist and Album ID
                                                  return AlbumCardSearch(
                                                      album: albums[index],
                                                      index: index);
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height:
                                            provider.searchedMusics.length > 0
                                                ? 350
                                                : 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tracks',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 330,
                                              child: ListView.builder(
                                                itemCount: provider
                                                    .searchedMusics.length,
                                                itemBuilder: ((context, index) {
                                                  return MusicCardsearch(
                                                    music: provider
                                                        .searchedMusics[index],
                                                    musics:
                                                        provider.searchedMusics,
                                                    artistname: provider
                                                        .searchedMusics[index]
                                                        .artist,
                                                    musicIndex: index,
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, hint, provider) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        autofocus: true,
        controller: searchController,
        style: const TextStyle(color: kGrey),
        cursorColor: kGrey,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(9)),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
