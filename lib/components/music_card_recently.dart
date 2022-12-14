import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';

// ignore: must_be_immutable
class MusicCardRecently extends StatefulWidget {
  final double width, aspectRatio;
  final Music music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;
  MusicCardRecently(
      {Key? key,
      this.width = 125,
      this.aspectRatio = 1.02,
      required this.music,
      required this.musics,
      this.musicIndex = -1,
      this.isForPlaylist})
      : super(key: key);

  @override
  State<MusicCardRecently> createState() => _MusicCardRecentlyState();
}

class _MusicCardRecentlyState extends State<MusicCardRecently> {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    var p = Provider.of<MusicPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicProvider>(context);
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return SizedBox(
          // height: 50,
          width: getProportionateScreenWidth(widget.width),
          child: GestureDetector(
            onTap: () {
              p.albumMusicss = widget.musics;
              p.isPlayingLocal = false;

              p.setBuffering(widget.musicIndex);
              if (checkConnection(status)) {
                if (p.isMusicInProgress(widget.music)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NowPlayingMusic(widget.music),
                    ),
                  );
                } else {
                  radioProvider.player.stop();
                  podcastProvider.player.stop();
                  p.player.stop();

                  p.setMusicStopped(true);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();
                  podcastProvider.listenPodcastStreaming();
                  p.setPlayer(p.player, podcastProvider, radioProvider);

                  p.handlePlayButton(
                      music: widget.music,
                      index: widget.musicIndex,
                      album: Album(
                        id: -2,
                        title: 'Single Music ${widget.musicIndex}',
                        artist: 'kin',
                        description: '',
                        cover: 'assets/images/kin.png',
                        count: widget.musics.length,
                        artist_id: 1,
                        isPurchasedByUser: false,
                        price: 60,
                      ),
                      musics: widget.musics);

                  p.setMusicStopped(false);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();
                  podcastProvider.listenPodcastStreaming();

                  // add to recently played
                  musicProvider.addToRecentlyPlayed(music: widget.music);

                  // add to popular
                  musicProvider.countPopular(music: widget.music);
                }
              } else {
                kShowToast(message: "No Connection");
              }
            },
            child: CachedNetworkImage(
                imageUrl: '$kinAssetBaseUrl/${widget.music.cover}',
                imageBuilder: (context, image) {
                  return Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            opacity: 0.4, fit: BoxFit.cover, image: image),
                        //color:  Colors.red.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              height: 100,
                              imageUrl:
                                  '$kinAssetBaseUrl/${widget.music.cover}',
                              fit: BoxFit.cover,
                              width:
                                  getProportionateScreenWidth(widget.width) / 2,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: getProportionateScreenWidth(90),
                              child: Text(
                                widget.music.title,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ),
                            Column(
                              children: [
                                p.currentMusic == null
                                    ? Container()
                                    : p.currentMusic!.title ==
                                            widget
                                                .musics[widget.musicIndex].title
                                        ? TrackMusicPlayButton(
                                            music: widget.music,
                                            index: widget.musicIndex,
                                            album: Album(
                                              id: -2,
                                              title:
                                                  'Single Music ${widget.musicIndex}',
                                              artist: 'kin',
                                              description: '',
                                              cover: 'assets/images/kin.png',
                                              count: widget.musics.length,
                                              artist_id: 6,
                                              isPurchasedByUser: false,
                                              price: 60,
                                            ),
                                          )
                                        : Container()
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
