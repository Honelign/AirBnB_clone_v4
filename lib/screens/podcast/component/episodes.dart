import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_podcast.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcastEpisode.dart';

import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Episodes extends StatelessWidget {
  Episodes(
      {Key? key,
      this.height = 70,
      this.aspectRatio = 1.02,
      required this.episode,
      required this.podCast,
      required this.episodeIndex,
      required this.episodes})
      : super(key: key);

  final double height, aspectRatio;
  final PodCastEpisode episode;
  final int episodeIndex;
  final List<PodCastEpisode> episodes;
  final PodCast podCast;

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<PodcastPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                p.setBuffering(episodeIndex);
                if (checkConnection(status)) {
                  if (p.isEpisodeInProgress(episode)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NowPlayingPodcast(episode)));
                  } else {
                    radioProvider.player.stop();
                    musicProvider.player.stop();
                    p.player.stop();

                    musicProvider.setMusicStopped(true);
                    p.setEpisodeStopped(true);
                    p.listenPodcastStreaming();
                    musicProvider.listenMusicStreaming();

                    p.setPlayer(p.player, musicProvider, radioProvider);
                    p.handlePlayButton(
                      episode: episode,
                      index: episodeIndex,
                      podCast: PodCast(
                          id: podCast.id,
                          title: podCast.title,
                          narrator: podCast.narrator,
                          description: podCast.description,
                          cover: podCast.cover,
                          episodes: episodes,
                          duration: podCast.duration),
                    );
                    p.setEpisodeStopped(false);
                    musicProvider.setMusicStopped(true);
                    p.listenPodcastStreaming();
                    musicProvider.listenMusicStreaming();
                  }
                } else {
                  kShowToast();
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20),
                    vertical: getProportionateScreenHeight(12.5)),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    height: getProportionateScreenHeight(height),
                    margin: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenHeight(8)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: AspectRatio(
                              aspectRatio: 1.1,
                              child: Container(
                                  color: kSecondaryColor.withOpacity(0.1),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '$kinAssetsBaseUrlOld/${podCast.cover}',
                                    fit: BoxFit.cover,
                                  )),
                            )),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                episode.title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${episode.duration} min",
                                      style: const TextStyle(color: kGrey),
                                    ),
                                    p.currentEpisode == null
                                        ? Container()
                                        : p.currentEpisode!.title ==
                                                podCast.episodes[episodeIndex]
                                                    .title
                                            ? TrackEpisodePlayButton(
                                                episode: episode,
                                                index: episodeIndex,
                                                podCast: podCast,
                                              )
                                            : Container()
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            )
          ],
        );
      },
    );
  }
}
