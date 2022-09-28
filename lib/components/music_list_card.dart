import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
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
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:provider/provider.dart';

class MusicListCard extends StatelessWidget {
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

            p.setBuffering(musicIndex);
            if (checkConnection(status)) {
              if (p.isMusicInProgress(music!)) {
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
                radioProvider.setMiniPlayerVisibility(false);
                p.handlePlayButton(
                    music: music!,
                    index: musicIndex,
                    album: Album(
                      id: -2,
                      title: 'Single Music $musicIndex',
                      artist: 'kin',
                      description: '',
                      cover: 'assets/images/kin.png',
                      count: musics.length,
                      artist_id: '1',
                      isPurchasedByUser: false,
                      price: '60',
                    ),
                    musics: musics);

                p.setMusicStopped(false);
                podcastProvider.setEpisodeStopped(true);
                p.listenMusicStreaming();
                podcastProvider.listenPodcastStreaming();

                // add to recently played
                musicProvider.addToRecentlyPlayed(music: music!);

                // add to popluar
                musicProvider.countPopular(music: music!);
              }
            } else {
              kShowToast();
            }
          },
          child: Container(
            height: getProportionateScreenHeight(height),
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
                          imageUrl: '$kinAssetBaseUrl/${music!.cover}',
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
                        music!.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              music!.artist.isNotEmpty
                                  ? music!.artist
                                  : 'kin artist',
                              style: const TextStyle(color: kGrey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          p.currentMusic == null
                              ? Container()
                              : p.currentMusic!.title ==
                                      musics[musicIndex].title
                                  ? TrackMusicPlayButton(
                                      music: music,
                                      index: musicIndex,
                                      album: Album(
                                        id: -2,
                                        title: 'Single Music $musicIndex',
                                        artist: 'kin',
                                        description: '',
                                        cover: 'assets/images/kin.png',
                                        count: musics.length,
                                        artist_id: '1',
                                        isPurchasedByUser: false,
                                        price: '60',
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
                                    color: Colors.white60, fontSize: 15),
                              ),
                              content: SizedBox(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      music!.description.isNotEmpty
                                          ? music!.description
                                          : '',
                                      style: const TextStyle(
                                          color: kLightSecondaryColor),
                                    ),
                                    Text(
                                      'By ${music!.artist}',
                                      style: const TextStyle(
                                          color: kLightSecondaryColor),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      // isForPlaylist == null
                      //     ? showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return AlertDialog(
                      //             backgroundColor: kPrimaryColor,
                      //             title: Text(
                      //               'Choose Playlist',
                      //               style: TextStyle(
                      //                 color: Colors.white.withOpacity(0.7),
                      //               ),
                      //             ),
                      //             content: SizedBox(
                      //               height: 200,
                      //               width: 200,
                      //               child: FutureBuilder<List<PlayListTitles>>(
                      //                 future: provider.getPlayListTitle(),
                      //                 builder: (context,
                      //                     AsyncSnapshot<List<PlayListTitles>>
                      //                         snapshot) {
                      //                   if (snapshot.hasData) {
                      //                     return ListView.builder(
                      //                       itemCount: snapshot.data!.length,
                      //                       shrinkWrap: true,
                      //                       scrollDirection: Axis.vertical,
                      //                       itemBuilder: (context, index) {
                      //                         return Consumer<PlayListProvider>(
                      //                           builder: (BuildContext context,
                      //                               provider, _) {
                      //                             return TextButton(
                      //                                 onPressed: () async {
                      //                                   var playlistInfo = {
                      //                                     'playlist_id':
                      //                                         snapshot
                      //                                             .data![index]
                      //                                             .id,
                      //                                     'track_id': music!.id
                      //                                   };
                      //                                   var result = await provider
                      //                                       .addMusicToPlaylist(
                      //                                           playlistInfo);

                      //                                   if (result) {
                      //                                     ScaffoldMessenger.of(
                      //                                             context)
                      //                                         .showSnackBar(
                      //                                       const SnackBar(
                      //                                         content: Text(
                      //                                             'Successfully added'),
                      //                                       ),
                      //                                     );
                      //                                   } else {
                      //                                     ScaffoldMessenger.of(
                      //                                             context)
                      //                                         .showSnackBar(
                      //                                       const SnackBar(
                      //                                         content: Text(
                      //                                             'Music Already added'),
                      //                                       ),
                      //                                     );
                      //                                   }
                      //                                   Navigator.of(context)
                      //                                       .pop();
                      //                                 },
                      //                                 child: Text(
                      //                                   snapshot
                      //                                       .data![index].title,
                      //                                   style: const TextStyle(
                      //                                     color:
                      //                                         kLightSecondaryColor,
                      //                                   ),
                      //                                 ));
                      //                           },
                      //                         );
                      //                       },
                      //                     );
                      //                   }
                      //                   return const Center(
                      //                     child: KinProgressIndicator(),
                      //                   );
                      //                 },
                      //               ),
                      //             ),
                      //           );
                      //         })
                      //     : showDialog(
                      //         context: context,
                      //         builder: (ctx) {
                      //           return AlertDialog(
                      //             backgroundColor: kPrimaryColor,
                      //             title: Text(
                      //               'Are You Sure ?',
                      //               style: TextStyle(
                      //                 color: Colors.white.withOpacity(0.7),
                      //               ),
                      //             ),
                      //             actions: [
                      //               TextButton(
                      //                 onPressed: () {
                      //                   Navigator.of(context).pop();
                      //                 },
                      //                 child: const Text(
                      //                   'No',
                      //                   style:
                      //                       TextStyle(color: kSecondaryColor),
                      //                 ),
                      //               ),
                      //               TextButton(
                      //                 onPressed: () async {
                      //                   final trackId = music!.id;
                      //                   final provider =
                      //                       Provider.of<PlayListProvider>(
                      //                           context,
                      //                           listen: false);
                      //                   var result =
                      //                       await provider.deleteFromPlaylist(
                      //                           trackId, playlistId);
                      //                   Navigator.of(ctx).pop();

                      //                   ScaffoldMessenger.of(ctx).showSnackBar(
                      //                     const SnackBar(
                      //                       content:
                      //                           Text('Successfully Removed'),
                      //                     ),
                      //                   );
                      //                 },
                      //                 child: const Text(
                      //                   'Yes',
                      //                   style:
                      //                       TextStyle(color: kSecondaryColor),
                      //                 ),
                      //               )
                      //             ],
                      //           );
                      //         });
                    }
                  },
                  itemBuilder: (context) {
                    return isForPlaylist != null
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
