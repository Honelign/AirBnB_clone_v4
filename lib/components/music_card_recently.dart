import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';

import '../constants.dart';
import '../size_config.dart';
import 'kin_progress_indicator.dart';

class MusicCardRecently extends StatefulWidget {
  MusicCardRecently(
      {Key? key,
      this.width = 125,
      this.aspectRatio = 1.02,
      required this.music,
      required this.musics,
      this.musicIndex = -1,
      this.isForPlaylist})
      : super(key: key);

  final double width, aspectRatio;
  final Music music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;

  @override
  State<MusicCardRecently> createState() => _MusicCardRecentlyState();
}

class _MusicCardRecentlyState extends State<MusicCardRecently> {
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
        return SizedBox(
          // height: 50,
          width: getProportionateScreenWidth(widget.width),
          child: GestureDetector(
            onTap: () {
              if (checkConnection(status)) {
                incrementMusicView(widget.music.id);
                p.setBuffering(widget.musicIndex);

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
                          count: widget.musics.length),
                      musics: widget.musics);

                  p.setMusicStopped(false);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();
                  podcastProvider.listenPodcastStreaming();

                  // add to popluar
                  musicProvider.countPopular(music: widget.music);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'No Connection',
                    style: TextStyle(color: kGrey),
                  ),
                ));
              }
            },
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: CachedNetworkImage(
                    height: 100,
                    imageUrl: '$kinAssetBaseUrl/${widget.music.cover}',
                    fit: BoxFit.cover,
                    width: getProportionateScreenWidth(widget.width) / 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xff333333).withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: getProportionateScreenWidth(80),
                            child: Text(
                              widget.music.title,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                          Column(
                            children: [
                              PopupMenuButton(
                                initialValue: 0,
                                child: const Icon(
                                  Icons.more_vert,
                                  color: Colors.transparent,
                                ),
                                onSelected: (value) {
                                  if (value == 2) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: kPrimaryColor,
                                            title: const Text(
                                              'Music Detail',
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontSize: 15),
                                            ),
                                            content: SizedBox(
                                              height: 100,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      widget.music.description
                                                              .isNotEmpty
                                                          ? widget
                                                              .music.description
                                                          : '',
                                                      style: const TextStyle(
                                                          color:
                                                              kLightSecondaryColor),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Text(
                                                      'By ${widget.music.artist}',
                                                      style: const TextStyle(
                                                          color:
                                                              kLightSecondaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor: kPrimaryColor,
                                            title: Text(
                                              'Choose Playlist',
                                              style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                            content: SizedBox(
                                              height: 200,
                                              width: 200,
                                              child: FutureBuilder<
                                                  List<PlayListTitles>>(
                                                future:
                                                    provider.getPlayListTitle(),
                                                builder: (context,
                                                    AsyncSnapshot<
                                                            List<
                                                                PlayListTitles>>
                                                        snapshot) {
                                                  if (snapshot.hasData) {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount:
                                                          snapshot.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Consumer<
                                                            PlayListProvider>(
                                                          builder: (BuildContext
                                                                  context,
                                                              provider,
                                                              _) {
                                                            return TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  var playlistInfo =
                                                                      {
                                                                    'playListTitleId':
                                                                        snapshot
                                                                            .data![index]
                                                                            .id,
                                                                    'musicId':
                                                                        widget
                                                                            .music
                                                                            .id
                                                                  };
                                                                  var result =
                                                                      await provider
                                                                          .addMusicToPlaylist(
                                                                              playlistInfo);

                                                                  if (result) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Successfully added'),
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        content:
                                                                            Text('Music Already added'),
                                                                      ),
                                                                    );
                                                                  }
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  snapshot
                                                                      .data![
                                                                          index]
                                                                      .title,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kLightSecondaryColor),
                                                                ));
                                                          },
                                                        );
                                                      },
                                                    );
                                                  }
                                                  return const Center(
                                                    child:
                                                        KinProgressIndicator(),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        });
                                  }
                                },
                                itemBuilder: (context) {
                                  return kMusicPopupMenuItem;
                                },
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
                                              count: widget.musics.length),
                                        )
                                      : Container()
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
