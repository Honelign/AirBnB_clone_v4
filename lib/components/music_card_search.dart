import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/music_detail_display.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music_from_search.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';

import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../screens/now_playing/now_playing_music.dart';

// ignore: must_be_immutable
class MusicCardsearch extends StatelessWidget {
  MusicCardsearch(
      {Key? key,
      this.width = 125,
      this.aspectRatio = 1.02,
      required this.music,
      required this.musics,
      this.musicIndex = -1,
      this.isForPlaylist,
      required this.artistname})
      : super(key: key);

  final double width, aspectRatio;
  final Music music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;
  final String artistname;

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
          width: getProportionateScreenWidth(width),
          child: GestureDetector(
            onTap: () async {
              p.albumMusicss = musics;
              p.isPlayingLocal = false;
              p.setBuffering(musicIndex);
              if (checkConnection(status)) {
                // incrementMusicView(music.id);
                p.setBuffering(musicIndex);

                if (p.isMusicInProgress(music)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NowPlayingMusic(music),
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
                      music: music,
                      index: musicIndex,
                      // TODO:Replace
                      album: Album(
                        id: -2,
                        title: 'Single Music $musicIndex',
                        artist: 'kin',
                        description: '',
                        cover: 'assets/images/kin.png',
                        count: musics.length,
                        artist_id: 1,
                        isPurchasedByUser: false,
                        price: 60,
                      ),
                      musics: musics);

                  p.setMusicStopped(false);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();

                  podcastProvider.listenPodcastStreaming();
                  // p.setMiniPlayerVisibility(true);
                  // add to recently played
                  musicProvider.addToRecentlyPlayed(music: music);

                  // add to popluar
                  musicProvider.countPopular(music: music);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      height: 50,
                      imageUrl: '$kinAssetBaseUrl/${music.cover}',
                      fit: BoxFit.cover,
                      width: getProportionateScreenWidth(width) / 2,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 320,
                    padding: const EdgeInsets.only(left: 10),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: getProportionateScreenWidth(140),
                                  child: Text(
                                    music.title,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  width: getProportionateScreenWidth(140),
                                  child: Text(
                                    artistname,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
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
                                            return MusicDetailDisplay(
                                              music: music,
                                            );
                                          });
                                    } else {
                                      // TODO: Improve
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (context) {
                                      //       return AlertDialog(
                                      //         backgroundColor: kPrimaryColor,
                                      //         title: Text(
                                      //           'Choose Playlist',
                                      //           style: TextStyle(
                                      //               color: Colors.white
                                      //                   .withOpacity(0.7)),
                                      //         ),
                                      //         content: SizedBox(
                                      //           height: 200,
                                      //           width: 200,
                                      //           child: FutureBuilder<
                                      //               List<PlayListTitles>>(
                                      //             future: provider
                                      //                 .getPlayListTitle(),
                                      //             builder: (context,
                                      //                 AsyncSnapshot<
                                      //                         List<
                                      //                             PlayListTitles>>
                                      //                     snapshot) {
                                      //               if (snapshot.hasData) {
                                      //                 return ListView.builder(
                                      //                   shrinkWrap: true,
                                      //                   scrollDirection:
                                      //                       Axis.vertical,
                                      //                   itemCount: snapshot
                                      //                       .data!.length,
                                      //                   itemBuilder:
                                      //                       (context, index) {
                                      //                     return Consumer<
                                      //                         PlayListProvider>(
                                      //                       builder:
                                      //                           (BuildContext
                                      //                                   context,
                                      //                               provider,
                                      //                               _) {
                                      //                         return TextButton(
                                      //                           onPressed:
                                      //                               () async {
                                      //                             var playlistInfo =
                                      //                                 {
                                      //                               'playListTitleId':
                                      //                                   snapshot
                                      //                                       .data![index]
                                      //                                       .id,
                                      //                               'musicId':
                                      //                                   music.id
                                      //                             };
                                      //                             var result =
                                      //                                 await provider
                                      //                                     .addMusicToPlaylist(
                                      //                                         playlistInfo);

                                      //                             if (result) {
                                      //                               ScaffoldMessenger.of(
                                      //                                       context)
                                      //                                   .showSnackBar(const SnackBar(
                                      //                                       content:
                                      //                                           Text('Successfully added')));
                                      //                             } else {
                                      //                               ScaffoldMessenger.of(
                                      //                                       context)
                                      //                                   .showSnackBar(const SnackBar(
                                      //                                       content:
                                      //                                           Text('Music Already added')));
                                      //                             }
                                      //                             Navigator.of(
                                      //                                     context)
                                      //                                 .pop();
                                      //                           },
                                      //                           child: Text(
                                      //                             snapshot
                                      //                                 .data![
                                      //                                     index]
                                      //                                 .title,
                                      //                             overflow:
                                      //                                 TextOverflow
                                      //                                     .ellipsis,
                                      //                             style: const TextStyle(
                                      //                                 color:
                                      //                                     kLightSecondaryColor),
                                      //                           ),
                                      //                         );
                                      //                       },
                                      //                     );
                                      //                   },
                                      //                 );
                                      //               }
                                      //               return const Center(
                                      //                 child:
                                      //                     KinProgressIndicator(),
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
                                // p.currentMusic == null
                                //     ? Container()
                                //     : p.currentMusic!.title ==
                                //             musics[musicIndex].title
                                //         ? TrackMusicPlayButton(
                                //             music: music,
                                //             index: musicIndex,
                                //             // TODO: Replace
                                //             album: Album(
                                //               id: -2,
                                //               title: 'Single Music $musicIndex',
                                //               artist: 'kin',
                                //               description: '',
                                //               cover: 'assets/images/kin.png',
                                //               // cover:'$kinAssetBaseUrl/${music.cover}',
                                //               count: musics.length,
                                //               artist_id: 1,
                                //               isPurchasedByUser: false,
                                //               price: 60,
                                //             ),
                                //           )
                                //         : Container()
                              ],
                            ),
                          ],
                        ),
                        //        Container(
                        //         constraints: BoxConstraints(maxWidth: 100,maxHeight: 25),

                        //          child: Text(

                        //   '${music!.artist!.isNotEmpty?music!.artist:'kin artist'}',
                        //   overflow: TextOverflow.fade,
                        //   style: const TextStyle(color: kGrey,fontSize: 10),

                        // ),
                        //        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
