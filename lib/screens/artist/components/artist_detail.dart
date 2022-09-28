import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/coins/buy_coin.dart';
import 'package:kin_music_player_app/coins/components/tip_artist_card.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/artist/components/popular_tracks.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'artist_album.dart';

class ArtistDetail extends StatefulWidget {
  static String routeName = '/artistBody';
  final String artist_id;
  final Artist artist;

  const ArtistDetail({
    Key? key,
    required this.artist_id,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistDetail> createState() => _ArtistDetailState();
}

class _ArtistDetailState extends State<ArtistDetail> {
  final double MODAL_HEADER_HEIGHT = 220;

  @override
  void initState() {
    // TODO: implement initState
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false)
        .getArtistAlbums(widget.artist_id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: FutureBuilder(
        builder: (context, snapshot) {
          final album = snapshot.data;

          return SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    '$kinAssetBaseUrl/${widget.artist.artist_profileImage}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  color: kPrimaryColor.withOpacity(0.5),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                // artist header with name image
                                _buildHeader(),

                                // spacer
                                const SizedBox(
                                  height: 32,
                                ),

                                // tip button
                                _buildTipButton()
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(15),
                            ),
                            _buildAlbum(context),
                            SizedBox(
                              height: getProportionateScreenHeight(25),
                            ),
                            // _buildTrackList(context),
                          ],
                        ),
                      ),
                      BackButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Container(
        height: getProportionateScreenWidth(225),
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
                '$kinAssetBaseUrl/${widget.artist.artist_profileImage}'),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '$kinAssetBaseUrl/${widget.artist.artist_profileImage}'),
                    maxRadius: getProportionateScreenHeight(60),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Text(
                    widget.artist.artist_name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "albums ${widget.artist.noOfAlbums}",
                        // "${widget.artist.albums!.length.toString()} albums",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      Text(
                        "tracks ${widget.artist}",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildTipButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) {
                  // coin provider
                  final provider =
                      Provider.of<CoinProvider>(context, listen: false);

                  // UI
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      void refresherFunction() {
                        setState(() {});
                      }

                      return FutureBuilder(
                          future: provider.getCoinBalance(),
                          builder: (context, snapshot) {
                            // if loading coin balance
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                color: Colors.black,
                                child: KinProgressIndicator(),
                              );
                            }

// coin info got
                            else {
                              return Container(
                                color: kPrimaryColor,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Column(
                                  children: [
                                    // modal header
                                    buildModalHeader(
                                      remainingCoinValue: snapshot.hasData
                                          ? snapshot.data.toString()
                                          : "0",
                                    ),

                                    // modal list values
                                    buildCoinTipList(refresherFunction),
                                  ],
                                ),
                              );
                            }
                          });
                    },
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: kSecondaryColor,
              ),
              child: const Center(
                  child: Text(
                "Tip Artist",
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModalHeader({String remainingCoinValue = "0"}) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return SizedBox(
      height: MODAL_HEADER_HEIGHT,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          // spacer
          const SizedBox(
            height: 18,
          ),

          // title
          Text(
            "Coin Balance",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.75),
            ),
          ),

          // spacer
          const SizedBox(
            height: 8,
          ),

          // remaining coin value
          Text(
            "$remainingCoinValue ETB",
            style: TextStyle(
              fontSize: 32,
              color: Colors.white.withOpacity(0.75),
              fontWeight: FontWeight.bold,
            ),
          ),

          // spacer
          const SizedBox(
            height: 24,
          ),

          // buy coins button
          InkWell(
            onTap: () async {
              // remove modal sheet
              Navigator.pop(context);

              // route to buy coin page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BuyCoinPage(),
                ),
              );
            },
            child: Container(
              child: const Text(
                "Buy Coins",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),

          const SizedBox(
            height: 32,
          ),

          // tip artist
          Text(
            "Tip ${widget.artist.artist_name}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget buildCoinTipList(Function refreshParent) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return SizedBox(
      height: (MediaQuery.of(context).size.height * 0.7 - MODAL_HEADER_HEIGHT),
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: allowedCoinValues.length,
        itemBuilder: (BuildContext context, int index) {
          return TipArtistCard(
            value: allowedCoinValues[index],
            refresher: refreshParent,
            artistName: widget.artist.artist_name,
            artistId: widget.artist_id.toString(),
          );
        },
      ),
    );
  }

  Widget _buildAlbum(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Albums",
              press: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArtistAlbum(
                    albums: albumProvider.albums,
                     // widget.artist.albums!,
                    artistCover: widget.artist.artist_profileImage,
                  ),
                ));
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        SizedBox(
            height: getProportionateScreenHeight(450),
            child: GridView.builder(
              itemCount:
                  albumProvider.albums.length, //widget.artist.albums!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: getProportionateScreenWidth(25),
                mainAxisSpacing: getProportionateScreenWidth(25),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(25),
                vertical: getProportionateScreenHeight(25),
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                  ),
                  child: GridCard(
                    album: albumProvider
                        .albums[index], //widget.artist.albums![index],
                  ),
                );
              },
            ))
      ],
    );
  }

  Widget _buildTrackList(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context);
    return Column(children: [
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SectionTitle(
            title: "Popular Tracks",
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PopularTracks(
                        album_id: '5', //albumProvider.album.id.toString(),
                        artist: widget.artist,
                      )));
            }),
      ),
      SizedBox(height: getProportionateScreenHeight(20)),
      ListView.builder(
        itemCount: 5,
        // widget.artist.musics.length > 6 ? 6 : widget.artist.musics.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return MusicListCard(
            music: [] as Music, //widget.artist.musics[index],
            musics: [], //widget.artist.musics,
            musicIndex: index,
          );
        },
      )
    ]);
  }
}
