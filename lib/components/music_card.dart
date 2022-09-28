import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

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
import '../screens/playlist/playlist.dart';
import '../size_config.dart';
import 'kin_progress_indicator.dart';

class MusicCard extends StatefulWidget {
  MusicCard(
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
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
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
        return Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
          child: SizedBox(
            width: getProportionateScreenWidth(widget.width),
            child: InkWell(
              onTap: () async {
                if (checkConnection(status)) {
                  // incrementMusicView(music.id);
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
                          count: widget.musics.length,
                          artist_id: '1',
                          isPurchasedByUser: false,
                          price: '60',
                        ),
                        musics: widget.musics);

                    p.setMusicStopped(false);
                    podcastProvider.setEpisodeStopped(true);
                    p.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();

                    // add to recently played
                    musicProvider.addToRecentlyPlayed(music: widget.music);

                    // add to popluar
                    musicProvider.countPopular(music: widget.music);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '$kinAssetBaseUrl/${widget.music.cover}',
                              fit: BoxFit.cover,
                              width: getProportionateScreenWidth(widget.width),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: p.currentMusic == null
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
                                          artist_id: '1',
                                          isPurchasedByUser: false,
                                          price: '60',
                                        ),
                                      )
                                    : Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(100),
                          child: Text(
                            widget.music.title,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        ),
                        PopupMenuButton(
                          initialValue: 0,
                          child: const Icon(
                            Icons.more_vert,
                            color: kGrey,
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
                                                    ? widget.music.description
                                                    : '',
                                                style: const TextStyle(
                                                    color:
                                                        kLightSecondaryColor),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text('By ${widget.music.artist}',
                                                  style: const TextStyle(
                                                      color:
                                                          kLightSecondaryColor))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            } else {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         backgroundColor: kPrimaryColor,
                              //         title: Text(
                              //           'Choose Playlist',
                              //           style: TextStyle(
                              //               color:
                              //                   Colors.white.withOpacity(0.7)),
                              //         ),
                              //         content: SizedBox(
                              //           height: 200,
                              //           width: 200,
                              //           child:
                              //               FutureBuilder<List<PlayListTitles>>(
                              //             future: provider.getPlayListTitle(),
                              //             builder: (context,
                              //                 AsyncSnapshot //< List<PlayListTitles>>
                              //                     snapshot) {
                              //               if (snapshot.hasData) {
                              //                 return ListView.builder(
                              //                   shrinkWrap: true,
                              //                   scrollDirection: Axis.vertical,
                              //                   itemCount:
                              //                       snapshot.data!.length,
                              //                   itemBuilder: (context, index) {
                              //                     return Consumer<
                              //                         PlayListProvider>(
                              //                       builder:
                              //                           (BuildContext context,
                              //                               provider, _) {
                              //                         return TextButton(
                              //                             onPressed: () async {
                              //                               var playlistInfo = {
                              //                                 'playlist_id':
                              //                                     snapshot
                              //                                         .data![
                              //                                             index]
                              //                                         .id,
                              //                                 'track_id': widget
                              //                                     .music.id
                              //                               };

                              //                               var result = await provider
                              //                                   .addMusicToPlaylist(
                              //                                       playlistInfo);

                              //                               if (result) {
                              //                                 Navigator.of(
                              //                                         context)
                              //                                     .pushReplacement(
                              //                                   MaterialPageRoute(
                              //                                     builder:
                              //                                         (context) =>
                              //                                             const PlaylistsScreen(),
                              //                                   ),
                              //                                 );

                              //                                 ScaffoldMessenger
                              //                                         .of(context)
                              //                                     .showSnackBar(
                              //                                   const SnackBar(
                              //                                     content: Text(
                              //                                         'Successfully added'),
                              //                                   ),
                              //                                 );
                              //                                 setState(() {});
                              //                               } else {
                              //                                 setState(() {});
                              //                                 ScaffoldMessenger
                              //                                         .of(context)
                              //                                     .showSnackBar(
                              //                                   const SnackBar(
                              //                                     content: Text(
                              //                                       'Music Already added',
                              //                                     ),
                              //                                   ),
                              //                                 );
                              //                               }

                              //                               Navigator.of(
                              //                                       context)
                              //                                   .pop();
                              //                               setState(() {});
                              //                             },
                              //                             child: Text(
                              //                               snapshot
                              //                                   .data![index]
                              //                                   .title,
                              //                               overflow:
                              //                                   TextOverflow
                              //                                       .ellipsis,
                              //                               style:
                              //                                   const TextStyle(
                              //                                 color:
                              //                                     kLightSecondaryColor,
                              //                               ),
                              //                             ));
                              //                       },
                              //                     );
                              //                   },
                              //                 );
                              //               }
                              //               return const Center(
                              //                 child: KinProgressIndicator(),
                              //               );
                              //             },
                              //           ),
                              //         ),
                              //       );
                              //     });
                            }
                          },
                          itemBuilder: (context) {
                            return kMusicPopupMenuItem;
                          },
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.music.artist.isNotEmpty
                        ? widget.music!.artist
                        : 'kin artist',
                    style: const TextStyle(color: kGrey),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
