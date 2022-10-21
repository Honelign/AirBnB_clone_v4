import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_season.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

class EpisodeCard extends StatefulWidget {
  final PodcastEpisode podcastEpisode;
  final int index;
  final List<PodcastEpisode> podcasts;

  const EpisodeCard({
    Key? key,
    required this.podcastEpisode,
    required this.index,
    required this.podcasts,
  }) : super(key: key);

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    var p = Provider.of<PodcastPlayer>(
      context,
    );

    var musicProvider = Provider.of<MusicProvider>(context);
    var musicPlayer = Provider.of<MusicPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    OfflineMusicProvider offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(
      context,
      listen: false,
    );
    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return InkWell(
            onTap: () async {
              p.currentSeason = widget.podcasts;
              p.isPlayingLocal = false;
              p.setBuffering(widget.index);

              if (checkConnection(status)) {
                // incrementMusicView(music.id);
                p.setBuffering(widget.index);

                if (p.isEpisodeInProgress(widget.podcastEpisode)) {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => NowPlayingMusic(widget.podcastEpisode),
                  //   ),
                  // );
                } else {
                  radioProvider.player.stop();
                  musicPlayer.player.stop();
                  p.player.stop();

                  p.setEpisodeStopped(true);
                  musicPlayer.setMusicStopped(true);
                  p.listenMusicStreaming();
                  musicPlayer.listenMusicStreaming();

                  p.setPlayer(p.player, musicPlayer, radioProvider);

                  p.handlePlayButton(
                    episodes: widget.podcasts,
                    episode: widget.podcastEpisode,
                    index: widget.index,
                    // season: widget.podcasts,
                  );
                  // _musicPlayerController.setIsProcessingPlayToFalse();

                  p.setEpisodeStopped(false);
                  musicPlayer.setMusicStopped(true);
                  p.listenMusicStreaming();
                  musicPlayer.listenMusicStreaming();

                  // // add to recently played
                  // musicProvider.addToRecentlyPlayed(music: widget.p);

                  // // add to popular
                  // musicProvider.countPopular(music: widget.music);
                  print("PLAYING");
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No Connection',
                      style: TextStyle(color: kGrey),
                    ),
                  ),
                );
              }
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 18, 12, 0),
              width: MediaQuery.of(context).size.width - 24,
              height: 70,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Image
                      CachedNetworkImage(
                        imageUrl: "$kinAssetBaseUrl-dev/" +
                            widget.podcastEpisode.cover,
                        imageBuilder: (context, img) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: img,
                              ),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        width: 16,
                      ),

                      // Title
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // title
                          Text(
                            "Episode :  " + widget.podcastEpisode.episodeTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),

                          // spacer
                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ],
                  ),
                  isPlaying == true &&
                          p.currentEpisode != null &&
                          p.currentEpisode!.id == widget.podcastEpisode.id
                      ? Text("Playing")
                      : Text("Not Playing"),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: kGrey,
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
