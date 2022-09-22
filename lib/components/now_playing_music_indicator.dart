import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/payment/payment_component.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';

import '../constants.dart';
import '../screens/payment/stripe.dart';
import '../services/provider/favorite_music_provider.dart';
import '../size_config.dart';

class NowPlayingMusicIndicator extends StatefulWidget {
  const NowPlayingMusicIndicator({Key? key}) : super(key: key);

  @override
  State<NowPlayingMusicIndicator> createState() =>
      _NowPlayingMusicIndicatorState();
}

class _NowPlayingMusicIndicatorState extends State<NowPlayingMusicIndicator> {
  double minPlayerHeight = 70;
  @override
  void initState() {
    var favprovider =
        Provider.of<CachedFavoriteProvider>(context, listen: false);
    favprovider.getFavids();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(context, listen: false);
    var favprovider =
        Provider.of<CachedFavoriteProvider>(context, listen: false);
    Provider.of<FavoriteMusicProvider>(context, listen: false)
        .isMusicFav(p.currentMusic!.id);

    return Container(
      height: 125,
      color: kPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [],
                ),
              ),
              InkWell(
                onTap: () {
                  Future successFunction() async {
                    print("@@@@@lookie-payment-stripe");
                  }

                  Future refersherFunction() async {
                    print("@@@@@lookie-payment-stripe");
                  }

                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => PaymentComponent(
                      successFunction: successFunction,
                      paymentPrice: p.currentMusic!.priceETB.toString(),
                      refresherFunction: refersherFunction,
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  margin: const EdgeInsets.fromLTRB(0, 0, 6, 8),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.98),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "Buy 15 ETB",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
          PlayerBuilder.isPlaying(
              player: p.player,
              builder: (context, isPlaying) {
                return SizedBox(
                  height: minPlayerHeight,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      _buildBlurBackground(p.getMusicCover()),

                      _buildDarkContainer(),

                      Container(
                        height: 70,
                        color: Colors.transparent,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(
                          getProportionateScreenWidth(15),
                          getProportionateScreenHeight(10),
                          getProportionateScreenWidth(15),
                          getProportionateScreenHeight(10),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            p.setBuffering(p.tIndex);
                            p.isMusicInProgress(p.currentMusic!)
                                ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NowPlayingMusic(p.currentMusic),
                                    ),
                                  )
                                : p.handlePlayButton(
                                    music: p.currentMusic!,
                                    index: p.tIndex,
                                    album: p.currentAlbum,
                                    musics: p.albumMusics
                                  );
                          },
                          child: Row(
                            children: [
                              _buildCover(p),
                              SizedBox(
                                width: getProportionateScreenWidth(10),
                              ),
                              _buildTitleAndArtist(p.currentMusic!.title,
                                  p.currentMusic!.artist),
                              // _buildPreviousButton(p),
                              Consumer<FavoriteMusicProvider>(
                                builder: (context, provider, _) {
                                  // ignore: iterable_contains_unrelated_type
                                  return favprovider.favMusics
                                          .contains(p.currentMusic!.id)
                                      ? IconButton(
                                          onPressed: () async {
                                            favprovider.removeCachedFav(
                                                p.currentMusic!.id);
                                            favprovider.getFavids();
                                            await provider
                                                .unFavMusic(p.currentMusic!.id);

                                            await provider.getFavMusic();
                                          },
                                          icon: const Icon(
                                            Icons.favorite,
                                            color: kSecondaryColor,
                                          ))
                                      : IconButton(
                                          onPressed: () async {
                                            favprovider.addCachedFav(
                                                p.currentMusic!.id);
                                            favprovider.getFavids();
                                            await provider
                                                .favMusic(p.currentMusic!.id);

                                            // TODO: remove
                                            await Future.delayed(
                                              Duration(seconds: 1),
                                            );
                                            provider.getFavMusic();
                                          },
                                          icon: const Icon(
                                            Icons.favorite_border,
                                            color: Colors.white,
                                          ),
                                        );
                                },
                              ),
                              _buildPlayPauseButton(
                                p,
                              ),
                              _buildNextButton(p)
                            ],
                          ),
                        ),
                      ),

                      // _buildCloseButton(p),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget _buildBlurBackground(musicCover) {
    return ClipRect(
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          image: DecorationImage(
              image: CachedNetworkImageProvider(musicCover), fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const SizedBox(
            height: 70,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDarkContainer() {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryColor.withOpacity(0.25),
            kPrimaryColor.withOpacity(0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(provider) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1.02,
        child: Container(
          color: kSecondaryColor.withOpacity(0.1),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: '$kinAssetBaseUrl/${provider.currentMusic.cover}',
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndArtist(musicTitle, musicCover) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            musicTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            musicCover,
            style: const TextStyle(color: kGrey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton(MusicPlayer playerProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
      player: playerProvider.player,
      builder: (context, isPlaying) {
        return InkWell(
          onTap: () async {
            if (isPlaying || playerProvider.player.isBuffering.value) {
              playerProvider.player.pause();
            } else {
              if (checkConnection(status)) {
                playerProvider.player.play();
              } else {
                kShowToast();
              }
            }
          },
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(1000)),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15,
              child: isPlaying
                  ? SvgPicture.asset(
                      'assets/icons/pause.svg',
                      fit: BoxFit.contain,
                      color: Colors.white,
                    )
                  : SvgPicture.asset(
                      'assets/icons/play-triangle.svg',
                      fit: BoxFit.contain,
                      color: Colors.white,
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(Icons.skip_next),
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
}

// Widget _buildCloseButton(MusicPlayer provider) {
//   return Positioned(
//     top: -10,
//     right: -10,
//     child: IconButton(
//         onPressed: () async {
//           provider.player.stop();
//           provider.setMusicStopped(true);

//           setState(() {
//             minPlayerHeight = 0;
//           });
//         },
//         icon: const Icon(
//           Icons.clear,
//           color: kGrey,
//           size: 20,
//         )),
//   );
// }

// Widget _buildPreviousButton(MusicPlayer playerProvider) {
//   return IconButton(
//     icon: const Icon(Icons.skip_previous),
//     color: playerProvider.isFirstMusic() ? kGrey : Colors.white,
//     onPressed: () {
//       playerProvider.prev();
//     },
//   );
// }
