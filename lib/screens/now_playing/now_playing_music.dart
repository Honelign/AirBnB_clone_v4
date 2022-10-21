import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/coins/buy_coin.dart';
import 'package:kin_music_player_app/coins/components/tip_artist_card.dart';
import 'package:kin_music_player_app/components/animation_rotate.dart';
import 'package:kin_music_player_app/components/download/download_progress_display_component.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/payment/payment_component.dart';
import 'package:kin_music_player_app/components/playlist_selector_dialog.dart';
import 'package:kin_music_player_app/components/position_seek_widget.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show utf8;

import '../../constants.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';

import '../../services/provider/playlist_provider.dart';

class NowPlayingMusic extends StatefulWidget {
  static const String routeName = '/nowPlaying';
  final Music? musicForId;

  const NowPlayingMusic(this.musicForId, {Key? key}) : super(key: key);

  @override
  State<NowPlayingMusic> createState() => _NowPlayingMusicState();
}

class _NowPlayingMusicState extends State<NowPlayingMusic>
    with WidgetsBindingObserver {
  final double MODAL_HEADER_HEIGHT = 180;
  late int musicId;
  int selectedPlaylistId = 1;

  bool showLyric = false;

  @override
  void initState() {
    super.initState();

    musicId = widget.musicForId!.id;

    Provider.of<FavoriteMusicProvider>(context, listen: false)
        .isMusicFav(musicId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayListProvider>(context, listen: false);

    int index = 0;
    Music? music;
    musicId = widget.musicForId!.id;
    var playerProvider = Provider.of<MusicPlayer>(context);
    playerProvider.audioSessionListener();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        toolbarHeight: 0,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      ),
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PlayerBuilder.realtimePlayingInfos(
            player: playerProvider.player,
            builder: (context, info) {
              music = playerProvider.currentMusic;
              return Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      '$kinAssetBaseUrl/${music!.cover}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container(
                    color: kPrimaryColor.withOpacity(0.4),
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                InkWell(
                                  child: const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                const Text(
                                  "Now Playing",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),

                          // album image
                          InkWell(
                            onTap: () {
                              setState(() {
                                showLyric = !showLyric;
                              });
                            },
                            child: showLyric == true
                                ? music!.lyrics != "null" &&
                                        music!.lyrics != null
                                    ? _buildScrollableLyrics(
                                        context,
                                        music!.lyrics,
                                      )
                                    : _buildScrollableLyrics(
                                        context,
                                        "No Lyric",
                                      )
                                : _buildAlbumCover(
                                    music: music!,
                                    playerProvider: playerProvider,
                                  ),
                          ),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(50),
                          ),
                          // song title
                          _buildSongTitle(music),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),

                          // action center
                          _buildActionCenter(music: music!),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),

                          //  progress bar
                          _buildProgressBar(info, music!, playerProvider),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),

                          // control center
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRepeatButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildPreviousButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildPlayPauseButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildNextButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildShuffleButton(playerProvider)
                            ],
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(25),
                            height: 20,
                          ),
                          // music!.lyrics!.isNotEmpty &&
                          //         music!.lyrics != "null" &&
                          //         music!.lyrics != null
                          //     ? _buildScrollableLyrics(
                          //         context,
                          //         utf8.decode(
                          //           music!.lyrics!
                          //               .replaceAll('<p>', '')
                          //               .replaceAll('</p>', '')
                          //               .replaceAll('\\r', '')
                          //               .replaceAll('\\n', '\n')
                          //               .replaceAll('\\', '')
                          //               .runes
                          //               .toList(),
                          //         ),
                          //       )
                          //     : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCover({
    required MusicPlayer playerProvider,
    required Music music,
  }) {
    return Container(
      height: 250,
      margin: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(30),
        horizontal: getProportionateScreenWidth(30),
      ),
      child: AnimationRotate(
        stop: !playerProvider.isPlaying(),
        child: SizedBox(
          height: 250,
          width: 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: Stack(
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: playerProvider.getMusicCover(),
                  height: 250,
                  width: 250,
                ),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.4),
                        const Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 75,
                      width: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                '$kinAssetBaseUrl/${music.cover}',
                              ),
                              // CachedNetworkImageProvider('$kinAssetBaseUrl/Media_Files/Artists_Profile_Images/Teddy Afro/Teddy_Afro_-_tedyafro.jpg'),
                              fit: BoxFit.cover)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                            ),
                          ),
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                '$kinAssetBaseUrl/${music.cover}'),
                            // CachedNetworkImageProvider('$kinAssetBaseUrl/Media_Files/Artists_Profile_Images/Teddy Afro/Teddy_Afro_-_tedyafro.jpg'),
                            fit: BoxFit.cover)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      RealtimePlayingInfos info, Music music, MusicPlayer playerProvider) {
    return PositionSeekWidget(
      currentPosition: info.currentPosition,
      duration: //just a dummy time if stream
          info.duration,
      seekTo: (to) {
        playerProvider.player.seek(to);
      },
    );
  }

  Widget _buildActionCenter({required Music music}) {
    var favprovider =
        Provider.of<CachedFavoriteProvider>(context, listen: false);
    OfflineMusicProvider offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(
      context,
      listen: false,
    );
    MusicPlayer p = Provider.of<MusicPlayer>(
      context,
      listen: false,
    );
    return Consumer<FavoriteMusicProvider>(builder: (context, provider, _) {
      return Container(
        width: MediaQuery.of(context).size.width,
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // favorite button
            IconButton(
              onPressed: () async {
                if (favprovider.favMusics.contains(music.id)) {
                  favprovider.removeCachedFav(music.id);
                  favprovider.getFavids();

                  await provider.unFavMusic(music.id);
                } else {
                  favprovider.addCachedFav(music.id);
                  favprovider.getFavids();
                  await provider.favMusic(music.id);
                }

                await provider.getFavMusic();
              },
              icon: favprovider.favMusics.contains(music.id)
                  ? Icon(
                      Icons.favorite,
                      color: kSecondaryColor.withOpacity(0.8),
                      size: 24,
                    )
                  : Icon(
                      Icons.favorite,
                      color: Colors.white.withOpacity(0.8),
                      size: 24,
                    ),
            ),

            // Tip Button
            IconButton(
              onPressed: () async {
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
                                    MediaQuery.of(context).size.height * 0.65,
                                decoration: linearGradientDecoration,
                                child: const KinProgressIndicator(),
                              );
                            }

                            // coin info got
                            else {
                              return Container(
                                decoration: linearGradientDecoration,
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Column(
                                  children: [
                                    // modal header
                                    SizedBox(
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
                                              color: Colors.white
                                                  .withOpacity(0.75),
                                            ),
                                          ),

                                          // spacer
                                          const SizedBox(
                                            height: 8,
                                          ),

                                          // remaining coin value
                                          Text(
                                            "${snapshot.data ?? '0'} ETB",
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: Colors.white
                                                  .withOpacity(0.75),
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
                                                  builder: (context) =>
                                                      const BuyCoinPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              child: const Text(
                                                "Buy Coins",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: kSecondaryColor,
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 8,
                                                horizontal: 25,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // modal list values
                                    SizedBox(
                                      height:
                                          (MediaQuery.of(context).size.height *
                                                  0.65 -
                                              MODAL_HEADER_HEIGHT),
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                        itemCount: allowedCoinValues.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return TipArtistCard(
                                            value: allowedCoinValues[index],
                                            refresher: refresherFunction,
                                            artistName: music.artist,
                                            artistId: music.artist_id,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.card_giftcard_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ),

            // buy
            IconButton(
              onPressed: () async {
                // not purchased
                if (p.currentMusic!.isPurchasedByUser == false) {
                  // payment modal
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => PaymentComponent(
                      trackId: (p.currentMusic!.id),
                      paymentPrice: p.currentMusic!.priceETB.toString(),
                      paymentReason: "trackPurchase",
                      onSuccessFunction: () {},
                    ),
                  );
                }

                //  purchased
                else {
                  kShowToast(message: "Track already purchased");
                }
              },
              icon: Icon(
                Icons.monetization_on,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                if (Provider.of<MusicPlayer>(context).isPlayingLocal == false) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return PlaylistSelectorDialog(
                        trackId: musicId.toString(),
                      );
                    },
                  );
                }
              },
              icon: Icon(
                Icons.add,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ),

            // Download
            IconButton(
              onPressed: () async {
                bool isMusicDownloaded =
                    await offlineMusicProvider.checkTrackInOfflineCache(
                  musicId: music.id.toString(),
                );

                if (isMusicDownloaded == true) {
                  kShowToast(message: "Music already available offline");
                } else {
                  // request permission
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.storage,
                    //add more permission to request here.
                  ].request();
                  if (statuses[Permission.storage]!.isGranted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DownloadProgressDisplayComponent(
                          music: music,
                        );
                      },
                    );
                  } else {
                    kShowToast(message: "Storage Permission Denied");
                  }
                }
              },
              icon: Icon(
                Icons.download,
                color: Colors.white.withOpacity(0.8),
                size: 24,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSongTitle(Music? music) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                music!.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            music.artist.isNotEmpty ? music.artist : "kin artist",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: kGrey,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRepeatButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: Icon(
        !playerProvider.loopPlaylist && playerProvider.loopMode
            ? Icons.repeat_one_rounded
            : Icons.repeat_rounded,
        size: 20,
      ),
      color: playerProvider.shuffled ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleLoop(),
    );
  }

  Widget _buildPreviousButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_previous_rounded,
        size: 28,
      ),
      color: playerProvider.isFirstMusic() ? kGrey : Colors.white,
      onPressed: () {
        playerProvider.prev();
      },
    );
  }

  Widget _buildPlayPauseButton(MusicPlayer playerProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
      player: playerProvider.player,
      builder: (context, isPlaying) {
        return InkWell(
          onTap: () {
            if (playerProvider.isProcessingPlay == false) {
              if (isPlaying || playerProvider.player.isBuffering.value) {
                playerProvider.player.pause();
              } else {
                if (checkConnection(status)) {
                  playerProvider.player.play();
                }
              }
            }
          },
          child: !playerProvider.isMusicLoaded
              ? SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven ? kSecondaryColor : Colors.white,
                      ),
                    );
                  },
                  size: 30,
                )
              : isPlaying
                  ? const Icon(
                      Icons.pause_rounded,
                      size: 36,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.play_arrow_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
        );
      },
    );
  }

  Widget _buildNextButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 28,
      ),
      color: playerProvider.isLastMusic(playerProvider.currentIndex! + 1)
          ? kGrey
          : Colors.white,
      onPressed: () {
        if (playerProvider.isLastMusic(playerProvider.currentIndex! + 1)) {
          return;
        }
        playerProvider.next();
      },
    );
  }

  Widget _buildShuffleButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.shuffle_rounded,
        size: 20,
      ),
      color: playerProvider.shuffled ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleShuffle(),
    );
  }

  Widget _buildScrollableLyrics(BuildContext context, lyrics) {
    // return GestureDetector(
    //   dragStartBehavior: DragStartBehavior.start,
    //   onVerticalDragStart: (DragStartDetails dragStartDetails) {
    //     showMaterialModalBottomSheet(
    //       context: context,
    //       builder: (context) => SizedBox(
    //         height: MediaQuery.of(context).size.height * 0.7,
    //         width: double.infinity,
    //         child: BackdropFilter(
    //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //           child: Container(
    //             alignment: Alignment.topCenter,
    //             decoration: BoxDecoration(
    //               color: kGrey.withOpacity(0.2),
    //               borderRadius: const BorderRadius.only(
    //                 topLeft: Radius.circular(50),
    //                 topRight: Radius.circular(50),
    //               ),
    //             ),
    //             child: SingleChildScrollView(
    //               padding: EdgeInsets.only(
    //                 top: getProportionateScreenHeight(50),
    //                 left: getProportionateScreenWidth(100),
    //               ),
    //               child: SizedBox(
    //                 width: double.infinity,
    //                 child:
    //                     // child: Html(
    //                     //   data: lyrics,

    //                     //   style: {
    //                     //     'p': Style(
    //                     //         color: Colors.white,
    //                     //         fontFamily: 'Nokia',
    //                     //         lineHeight: LineHeight.number(2))
    //                     //   },
    //                     // )
    //                     Text(
    //                   lyrics,
    //                   style: TextStyle(
    //                     color: Colors.white.withOpacity(0.7),
    //                     fontFamily: 'Nokia',
    //                     fontSize: 18,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    //   child: Container(
    //     height: 70,
    //     decoration: BoxDecoration(
    //       color: kGrey.withOpacity(0.15),
    //       borderRadius: const BorderRadius.only(
    //         topLeft: Radius.circular(50),
    //         topRight: Radius.circular(50),
    //       ),
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: const [
    //         Icon(
    //           Icons.expand_less,
    //           color: kSecondaryColor,
    //         ),
    //         Center(
    //           child: Text(
    //             'Lyrics',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          margin: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(30),
            horizontal: getProportionateScreenWidth(30),
          ),
          color: Colors.transparent,
          child: lyrics == "No Lyric"
              ? Center(
                  child: Text(
                    lyrics,
                    style: headerOneTextStyle,
                  ),
                )
              : Center(
                  child: Html(
                    data: lyrics,
                    style: {
                      'p': Style(
                        color: Colors.white,
                        fontFamily: "Nokia",
                        lineHeight: LineHeight.number(2),
                      ),
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
