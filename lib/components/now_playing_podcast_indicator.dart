import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:kin_music_player_app/components/payment/payment_component.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/payment_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class NowPlayingPodcastIndicator extends StatefulWidget {
  final String episodePrice;
  final bool isPurchased;
  const NowPlayingPodcastIndicator(
      {Key? key, required this.episodePrice, required this.isPurchased})
      : super(key: key);

  @override
  State<NowPlayingPodcastIndicator> createState() =>
      _NowPlayingPodcastIndicatorState();
}

class _NowPlayingPodcastIndicatorState
    extends State<NowPlayingPodcastIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<PodcastPlayer>(context, listen: false);
    bool showBuyButton = !widget.isPurchased;

    void onTrackPurchaseSuccess() async {
      setState(() {
        showBuyButton = false;
      });
    }

    PodcastProvider podcastProvider = Provider.of<PodcastProvider>(context);

    PaymentProvider paymentProvider = Provider.of<PaymentProvider>(context);

    // get providers

    // var favoriteProvider =
    //     Provider.of<CachedFavoriteProvider>(context, listen: false);
    // Provider.of<FavoriteMusicProvider>(context, listen: false)
    //     .isMusicFav(p.currentMusic!.id);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return SizedBox(
          height: minPlayerHeight,
          width: double.infinity,
          child: Stack(
            children: [
              _buildBlurBackground(
                p.getEpisodeCover(),
              ),
              _buildDarkContainer(),
              InkWell(
                onTap: () {
                  p.setBuffering(p.tIndex);
                  p.isEpisodeInProgress(p.currentEpisode!);
                  // ?
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           NowPlayingMusic(p.currentMusic),
                  //     ),
                  //   )
                  // : Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           NowPlayingMusic(p.currentMusic),
                  //     ),
                  //   );
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
                        p.currentEpisode!.episodeTitle,
                        p.currentEpisode!.hostName,
                      ),

                      showBuyButton == true
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
                                          trackId: (p.currentEpisode!.id),
                                          paymentPrice: p
                                              .currentEpisode!.priceETB
                                              .toString(),
                                          paymentReason: "trackPurchase",
                                          onSuccessFunction:
                                              onTrackPurchaseSuccess,
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
                                        "Buy ${widget.episodePrice} ETB",
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
            imageUrl: '$kinAssetBaseUrl-dev/${provider.currentEpisode.cover}',
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

  Widget _buildPlayPauseButton(PodcastPlayer playerProvider) {
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

  Widget _buildNextButton(PodcastPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 30,
      ),
      color: playerProvider.isLastEpisode(playerProvider.currentIndex! + 1)
          ? kGrey
          : Colors.white,
      onPressed: () {
        if (playerProvider.isLastEpisode(playerProvider.currentIndex! + 1)) {
          return;
        }
        if (playerProvider.isProcessingPlay == false) {
          playerProvider.next();
        }
      },
    );
  }
}
