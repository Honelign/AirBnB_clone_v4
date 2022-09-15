import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_podcast.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../size_config.dart';

class NowPlayingPodcastIndicator extends StatefulWidget {
  const NowPlayingPodcastIndicator({Key? key}) : super(key: key);

  @override
  State<NowPlayingPodcastIndicator> createState() =>
      _NowPlayingPodcastIndicatorState();
}

class _NowPlayingPodcastIndicatorState
    extends State<NowPlayingPodcastIndicator> {
  double minPlayerHeight = 70;

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PodcastPlayer>(context);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return SizedBox(
          height: minPlayerHeight,
          width: double.infinity,
          child: Stack(
            children: [
              _buildBlurBackground(p.getEpisodeCover()),
              _buildDarkContainer(),
              Container(
                height: 70,
                color: Colors.transparent,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(20),
                    getProportionateScreenHeight(10),
                    getProportionateScreenWidth(30),
                    getProportionateScreenHeight(10)),
                child: GestureDetector(
                  onTap: () {
                    p.setBuffering(p.tIndex);
                    p.isEpisodeInProgress(p.currentEpisode!)
                        ? Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NowPlayingPodcast(p.currentEpisode)))
                        : p.handlePlayButton(
                            episode: p.currentEpisode!,
                            index: p.tIndex,
                            podCast: p.currentPodcast,
                          );
                  },
                  child: Row(
                    children: [
                      _buildCover(p.getEpisodeCover()),
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                      _buildTitleAndArtist(
                        p.currentEpisode!.title,
                      ),
                      _buildPlayPauseButton(
                        p,
                      ),
                    ],
                  ),
                ),
              ),
              _buildCloseButton(p),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBlurBackground(musicCover) {
    return ClipRect(
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
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

  Widget _buildCover(podcastCover) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 1.02,
          child: Container(
              color: kSecondaryColor.withOpacity(0.1),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: podcastCover,
              )),
        ));
  }

  Widget _buildTitleAndArtist(
    musicTitle,
  ) {
    return Expanded(
      child: Text(
        musicTitle,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildPlayPauseButton(PodcastPlayer playerProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
      player: playerProvider.player,
      builder: (context, isPlaying) {
        return InkWell(
          onTap: () {
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
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kSecondaryColor, kPrimaryColor.withOpacity(0.75)],
                ),
                borderRadius: BorderRadius.circular(1000)),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 15,
              child: SvgPicture.asset(
                isPlaying
                    ? 'assets/icons/pause.svg'
                    : 'assets/icons/play-triangle.svg',
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCloseButton(PodcastPlayer provider) {
    return Positioned(
      top: -10,
      right: -10,
      child: IconButton(
        onPressed: () async {
          provider.player.stop();
          provider.setEpisodeStopped(true);
          setState(() {
            minPlayerHeight = 0;
          });
        },
        icon: const Icon(
          Icons.clear,
          color: kGrey,
          size: 15,
        ),
      ),
    );
  }
}
