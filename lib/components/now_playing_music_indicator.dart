import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/payment/payment_component.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/payment_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';

class NowPlayingMusicIndicator extends StatefulWidget {
  final String trackPrice;
  final bool isPurchased;
  const NowPlayingMusicIndicator(
      {Key? key, required this.trackPrice, required this.isPurchased})
      : super(key: key);

  @override
  State<NowPlayingMusicIndicator> createState() =>
      _NowPlayingMusicIndicatorState();
}

class _NowPlayingMusicIndicatorState extends State<NowPlayingMusicIndicator> {
  @override
  void initState() {
    var favoriteProvider =
        Provider.of<CachedFavoriteProvider>(context, listen: false);
    favoriteProvider.getFavids();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(context);

    MusicProvider musicProvider = Provider.of<MusicProvider>(context);

    PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context);

    // get providers

    var favoriteProvider =
        Provider.of<CachedFavoriteProvider>(context, listen: false);
    Provider.of<FavoriteMusicProvider>(context, listen: false)
        .isMusicFav(p.currentMusic!.id);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return SizedBox(
          height: minPlayerHeight,
          width: double.infinity,
          child: Stack(
            children: [
              _buildBlurBackground(p.getMusicCover()),
              _buildDarkContainer(),
              GestureDetector(
                onTap: () {
                  p.setBuffering(p.tIndex);
                  p.isMusicInProgress(p.currentMusic!)
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NowPlayingMusic(p.currentMusic),
                          ),
                        )
                      : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                NowPlayingMusic(p.currentMusic),
                          ),
                        );
                },
                child: Container(
                  height: minPlayerHeight,
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(8),
                    getProportionateScreenWidth(15),
                    getProportionateScreenHeight(8),
                  ),
                  child: Row(
                    children: [
                      // small image
                      _buildCover(p),

                      // spacer
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),

                      // title info
                      _buildTitleAndArtist(
                        p.currentMusic!.title,
                        p.currentMusic!.artist,
                      ),

                      (p.currentMusic!.isPurchasedByUser == false &&
                              p.purchaseStatus == false &&
                              p.currentMusic!.priceETB != "0")
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // payment modal
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => PaymentComponent(
                                          trackId: (p.currentMusic!.id),
                                          paymentPrice: p.currentMusic!.priceETB
                                              .toString(),
                                          paymentReason: "trackPurchase",
                                          onSuccessFunction: () {},
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 8,
                                      ),
                                      margin:
                                          const EdgeInsets.fromLTRB(0, 0, 6, 8),
                                      decoration: BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        "Buy ${widget.trackPrice} ETB",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.55,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                // favorite button
                                Consumer<FavoriteMusicProvider>(
                                  builder: (context, provider, _) {
                                    return favoriteProvider.favMusics
                                            .contains(p.currentMusic!.id)
                                        ? IconButton(
                                            onPressed: () async {
                                              favoriteProvider.removeCachedFav(
                                                  p.currentMusic!.id);
                                              favoriteProvider.getFavids();
                                              await provider.unFavMusic(
                                                  p.currentMusic!.id);

                                              await provider.getFavMusic();
                                            },
                                            icon: const Icon(
                                              Icons.favorite,
                                              color: kSecondaryColor,
                                              size: 23,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () async {
                                              favoriteProvider.addCachedFav(
                                                  p.currentMusic!.id);
                                              favoriteProvider.getFavids();
                                              await provider
                                                  .favMusic(p.currentMusic!.id);

                                              await provider.getFavMusic();
                                            },
                                            icon: const Icon(
                                              Icons.favorite_border,
                                              color: Colors.white,
                                              size: 23,
                                            ),
                                          );
                                  },
                                ),

                                // play button
                                _buildPlayPauseButton(
                                  p,
                                ),

                                // next button
                                _buildNextButton(p),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // build UI
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
            image: CachedNetworkImageProvider(musicCover),
            fit: BoxFit.cover,
          ),
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
      borderRadius: BorderRadius.circular(15),
      child: AspectRatio(
        aspectRatio: 1.0,
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
            maxLines: 1,
          ),
          Text(
            musicCover,
            style: const TextStyle(color: kGrey),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
              if (checkConnection(status) &&
                  playerProvider.isProcessingPlay == false) {
                playerProvider.player.play();
              }
            }
          },
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
            ),
            child: isPlaying
                ? const Icon(
                    Icons.pause_rounded,
                    size: 30,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.play_arrow_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 30,
      ),
      color: playerProvider.isLastMusic(playerProvider.currentIndex! + 1)
          ? kGrey
          : Colors.white,
      onPressed: () {
        if (playerProvider.isLastMusic(playerProvider.currentIndex! + 1)) {
          return;
        }
        if (playerProvider.isProcessingPlay == false) {
          playerProvider.next();
        }
      },
    );
  }
}
