import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/playlist_selector_dialog.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class AlbumCard extends StatefulWidget {
  const AlbumCard({
    Key? key,
    required this.album,
    this.musicIndex = -1,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.music,
    required this.albumMusics,
  }) : super(key: key);

  final double height, aspectRatio;
  final Music music;
  final int musicIndex;
  final Album album;
  final List<Music> albumMusics;

  @override
  State<AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<AlbumCard> {
  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(
      context,
    );

    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    var musicProvider = Provider.of<MusicProvider>(context);
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Container(
          height: getProportionateScreenHeight(widget.height),
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10),
          ),
          child: InkWell(
            onTap: () async {
              p.albumMusicss = widget.albumMusics;
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
                    album: widget.album,
                    musics: widget.albumMusics,
                  );
                }

                p.setMusicStopped(false);
                podcastProvider.setEpisodeStopped(true);
                p.listenMusicStreaming();
                podcastProvider.listenPodcastStreaming();

                // add to recently played
                musicProvider.addToRecentlyPlayed(music: widget.music);

                // add to popular
                musicProvider.countPopular(music: widget.music);
              } else {
                kShowToast();
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.02,
                    child: Container(
                      color: kSecondaryColor.withOpacity(0.1),
                      child: CachedNetworkImage(
                        imageUrl: '$kinAssetBaseUrl/${widget.music.cover}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Spacer
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),

                //
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Music title
                          Text(
                            widget.music.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // artist name
                          Text(
                            widget.music.artist,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(color: kGrey),
                          )
                        ],
                      ),

                      // POPUP menu & Playing wave
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // playing wave
                          p.currentMusic == null
                              ? Container()
                              : p.currentMusic!.title ==
                                      widget
                                          .albumMusics[widget.musicIndex].title
                                  ? TrackMusicPlayButton(
                                      music: widget.music,
                                      index: widget.musicIndex,
                                      album: widget.album,
                                    )
                                  : Container(),

                          // Spacer
                          const SizedBox(
                            width: 4,
                          ),

                          // POP UP MENU
                          PopupMenuButton(
                            initialValue: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.more_vert,
                                  color: kGrey,
                                ),
                              ],
                            ),
                            color: kPopupMenuBackgroundColor,
                            onSelected: (value) {
                              if (value == 2) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor:
                                          kPopupMenuBackgroundColor,
                                      title: const Text(
                                        'Music Detail',
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 15,
                                        ),
                                      ),
                                      content: SizedBox(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.music.description,
                                              style: const TextStyle(
                                                color: kLightSecondaryColor,
                                              ),
                                            ),
                                            Text(
                                              'By ${widget.music.artist}',
                                              style: const TextStyle(
                                                color: kLightSecondaryColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return PlaylistSelectorDialog(
                                      trackId: widget.music.id.toString(),
                                    );
                                  },
                                );
                              }
                            },
                            itemBuilder: (context) {
                              return kMusicPopupMenuItem;
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
