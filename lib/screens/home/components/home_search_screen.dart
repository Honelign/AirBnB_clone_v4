import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_card_recently.dart';
import 'package:kin_music_player_app/components/music_card_search.dart';
import 'package:kin_music_player_app/components/search/track_search_card.dart';
import 'package:kin_music_player_app/components/search/youtube_search_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/home/components/album_search_result.dart';
import 'package:kin_music_player_app/screens/home/components/artist_search_result.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

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
    searchController.addListener(() {
      final provider = Provider.of<MusicProvider>(context, listen: false);
      if (searchController.text.isNotEmpty) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 100), () {
          provider.searchedMusic(searchController.text, currentSearchType);
          provider.searchedTrack(searchController.text);
          provider.searchedtrackcount(searchController.text);
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

    List searchedMusicsList = [];
    List? searchedTracks = [];
    List? searchedArtist = [];
    List? searchedAlbum = [];
    int count = provider.count;
    List<Music> musics = [];
    if (provider.searchedMusics.isNotEmpty) {
      for (int i = 0; i < provider.searchedMusics.length; i++) {
        searchedMusicsList.add(provider.searchedMusics[i]);
      }
    }
    if (provider.searchedTracks != null &&
        provider.searchedTracks!.length > 0) {
      for (int i = 0; i < provider.searchedTracks!.length; i++) {
        searchedTracks.add(provider.searchedTracks![i]);
        musics.add(
          Music(
            artist: searchedTracks[i].artistId.artistName,
            audio: searchedTracks[i].trackFile,
            cover: searchedTracks[i].albumId.albumCover,
            description: searchedTracks[i].trackDescription,
            id: searchedTracks[i].id,
            title: searchedTracks[i].trackName,
            artist_id: searchedTracks[i].artistId.id.toString(),
            isPurchasedByUser: false,
            priceETB: 32.50.toString(),
            priceUSD: 0.99.toString(),
          ),
        );
      }
    }

    if (provider.searchedArtist != null &&
        provider.searchedArtist!.length > 0) {
      for (int i = 0; i < provider.searchedArtist!.length; i++) {
        searchedArtist.add(provider.searchedArtist![i]);
      }
    }
    if (provider.searchedAlbum != null && provider.searchedAlbum!.length > 0) {
      for (int i = 0; i < provider.searchedAlbum!.length; i++) {
        searchedAlbum.add(provider.searchedAlbum![i]);
      }
    }

    //if(pro)
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.35),
                    ],
                  ),
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

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              color: Colors.white.withOpacity(0.1),
                            ),
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: Center(
                              child: DropdownButton(
                                underline: Container(),
                                value: currentSearchType,
                                style: TextStyle(
                                    color: Colors.red,
                                    overflow: TextOverflow.ellipsis),
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                ),
                                // Array list of items
                                items: possibleSearchTypes.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style: TextStyle(color: kGrey),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentSearchType = newValue!;
                                    title = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: title == 'track'
                            ? Expanded(
                                child: provider.isLoading == true
                                    ? KinProgressIndicator()
                                    : count == 0
                                        ? provider.searchedMusics.isEmpty
                                            ? const Center(
                                                child: Text(
                                                'No data',
                                                style: TextStyle(color: kGrey),
                                              ))
                                            : ListView.builder(
                                                itemCount: provider
                                                    .searchedMusics.length,
                                                itemBuilder: (context, index) {
                                                  // return MusicListCard(
                                                  //   music: provider.searchedMusics[index],
                                                  //   musics: searchedMusicsList,
                                                  //   musicIndex: index,
                                                  // );
                                                  return YoutubeSearchCard(
                                                    result: searchedMusicsList[
                                                        index],
                                                  );
                                                },
                                              )
                                        : ListView.builder(
                                            itemCount: searchedTracks.length,
                                            itemBuilder: ((context, index) {
                                              return MusicCardsearch(
                                                artistname:
                                                    searchedTracks[index]
                                                        .artistId
                                                        .artistName,
                                                music: Music(
                                                  isPurchasedByUser: false,
                                                  priceETB: 32.50.toString(),
                                                  priceUSD: 0.99.toString(),
                                                  artist_id:
                                                      searchedTracks[index]
                                                          .artistId
                                                          .id
                                                          .toString(),
                                                  artist: searchedTracks[index]
                                                      .artistId
                                                      .artistName,
                                                  audio: searchedTracks[index]
                                                      .trackFile,
                                                  cover: searchedTracks[index]
                                                      .albumId
                                                      .albumCover,
                                                  description:
                                                      searchedTracks[index]
                                                          .trackDescription,
                                                  id: searchedTracks[index].id,
                                                  title: searchedTracks[index]
                                                      .trackName,
                                                ),
                                                musics: musics,
                                                musicIndex: index,
                                              );
                                            })))
                            : title == 'artist'
                                ? ArtistSearchResult(
                                    searchedMusicsList: searchedMusicsList,
                                    searchedArtistList: searchedArtist,
                                  )
                                : AlbumSearchResult(
                                    searchedMusicsList: searchedMusicsList,
                                    searchedAlbumList: searchedAlbum))
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, hint, provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
      ),
      child: TextFormField(
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
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(
            Icons.search,
            color: kGrey,
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
