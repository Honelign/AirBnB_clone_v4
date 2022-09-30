import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/playlist_selector_dialog.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';

import '../constants.dart';
import '../services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';

import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class MusicListCard extends StatefulWidget {
  MusicListCard(
      {Key? key,
      this.height = 70,
      this.aspectRatio = 1.02,
      required this.musics,
      required this.music,
      required this.musicIndex,
      this.isForPlaylist,
      this.playlistId})
      : super(key: key);

  final double height, aspectRatio;
  final Music? music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;
  int? playlistId;

  @override
  State<MusicListCard> createState() => _MusicListCardState();
}

class _MusicListCardState extends State<MusicListCard> {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    final provider = Provider.of<PlayListProvider>(context, listen: false);
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
        return GestureDetector(
          onTap: () {
            // incrementMusicView(music!.id);

            p.setBuffering(widget.musicIndex);
            if (checkConnection(status)) {
              if (p.isMusicInProgress(widget.music!)) {
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
                radioProvider.setMiniPlayerVisibility(false);
                p.handlePlayButton(
                    music: widget.music!,
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
                musicProvider.addToRecentlyPlayed(music: widget.music!);

                // add to popluar
                musicProvider.countPopular(music: widget.music!);
              }
            } else {
              kShowToast();
            }
          },
          child: Container(
            height: getProportionateScreenHeight(widget.height),
            width: getProportionateScreenWidth(75),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1.02,
                      child: Container(
                        color: kSecondaryColor.withOpacity(0.1),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: '$kinAssetBaseUrl/${widget.music!.cover}',
                        ),
                      ),
                    )),
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.music!.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.music!.artist.isNotEmpty
                                  ? widget.music!.artist
                                  : 'kin artist',
                              style: const TextStyle(color: kGrey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          p.currentMusic == null
                              ? Container()
                              : p.currentMusic!.title ==
                                      widget.musics[widget.musicIndex].title
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
                                        artist_id: 1,
                                        isPurchasedByUser: false,
                                        price: 60,
                                      ),
                                    )
                                  : Container()
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  initialValue: 0,
                  child: const Icon(
                    Icons.more_vert,
                    color: kPopupMenuForegroundColor,
                  ),
                  color: kPopupMenuBackgroundColor,
                  onSelected: (value) {
                    if (value == 2) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: kPopupMenuBackgroundColor,
                              title: const Text(
                                'Music Detail',
                                style: TextStyle(
                                  color: kPopupMenuForegroundColor,
                                  fontSize: 15,
                                ),
                              ),
                              content: SizedBox(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.music!.description.isNotEmpty
                                          ? widget.music!.description
                                          : '',
                                      style: const TextStyle(
                                        color: kLightSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      'By ${widget.music!.artist}',
                                      style: const TextStyle(
                                        color: kLightSecondaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return PlaylistSelectorDialog(
                            trackId: widget.music!.id.toString(),
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) {
                    return widget.isForPlaylist != null
                        ? kPlaylistPopupMenuItem
                        : kMusicPopupMenuItem;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
