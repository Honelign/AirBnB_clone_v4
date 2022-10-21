// import 'dart:ui';

// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kin_music_player_app/components/animation_rotate.dart';
// import 'package:kin_music_player_app/components/position_seek_widget.dart';
// import 'package:kin_music_player_app/screens/podcast/podcast.dart';
// import 'package:kin_music_player_app/services/connectivity_result.dart';
// import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
// import 'package:kin_music_player_app/services/network/model/podcast/podcast_season.dart';
// import 'package:kin_music_player_app/services/network/model/podcast_old/podcast.dart';
// import 'package:kin_music_player_app/services/network/model/podcast_old/podcastEpisode.dart';
// import 'package:kin_music_player_app/services/provider/podcast_player.dart';
// import 'package:provider/provider.dart';

// import '../../constants.dart';
// import '../../size_config.dart';

// class NowPlayingPodcast extends StatefulWidget {
//   static const String routeName = '/nowPlaying';
//   final PodcastEpisode? episodeForId;

//   const NowPlayingPodcast(this.episodeForId, {Key? key}) : super(key: key);

//   @override
//   State<NowPlayingPodcast> createState() => _NowPlayingPodcastState();
// }

// class _NowPlayingPodcastState extends State<NowPlayingPodcast> {
//   late int episodeId;

//   @override
//   void initState() {
//     episodeId = widget.episodeForId!.id;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     PodcastEpisode? episode;
//     PodcastSeason? podcastSeason;
//     episodeId = episode?.id ?? widget.episodeForId!.id;
//     var playerProvider = Provider.of<PodcastPlayer>(context);
//     playerProvider.audioSessionListener();

//     // return Scaffold(
//     //     backgroundColor: kPrimaryColor,
//     //     resizeToAvoidBottomInset: false,
//     //     appBar: AppBar(
//     //       title: const Text('Now Playing'),
//     //       elevation: 2,
//     //       backgroundColor: Colors.transparent,
//     //     ),
//     //     body: PlayerBuilder.realtimePlayingInfos(
//     //       player: playerProvider.player,
//     //       builder: (context, info) {
//     //         episode = playerProvider.currentEpisode;
//     //         podcastSeason = playerProvider.currentSeason;
//     //         return Container(
//     //           decoration: BoxDecoration(
//     //               image: DecorationImage(
//     //                   image: CachedNetworkImageProvider(
//     //                     '$apiUrl/${podcastSeason!.cover}',
//     //                   ),
//     //                   fit: BoxFit.cover)),
//     //           child: BackdropFilter(
//     //             filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//     //             child: Container(
//     //               color: kPrimaryColor.withOpacity(0.5),
//     //               child: Column(
//     //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     //                 children: [
//     //                   SizedBox(
//     //                     height: getProportionateScreenHeight(5),
//     //                   ),
//     //                   _buildAlbumCover(
//     //                     playerProvider,
//     //                     pod!,
//     //                   ),
//     //                   _buildSongTitle(episode, podCast!),
//     //                   SizedBox(
//     //                     height: getProportionateScreenHeight(25),
//     //                   ),
//     //                   _buildProgressBar(info, episode!, playerProvider),
//     //                   Row(
//     //                     mainAxisAlignment: MainAxisAlignment.center,
//     //                     children: [
//     //                       _buildRepeatButton(playerProvider),
//     //                       SizedBox(
//     //                         width: getProportionateScreenWidth(5),
//     //                       ),
//     //                       _buildPreviousButton(playerProvider),
//     //                       SizedBox(
//     //                         width: getProportionateScreenWidth(5),
//     //                       ),
//     //                       _buildPlayPauseButton(playerProvider),
//     //                       SizedBox(
//     //                         width: getProportionateScreenWidth(5),
//     //                       ),
//     //                       _buildNextButton(playerProvider),
//     //                       SizedBox(
//     //                         width: getProportionateScreenWidth(5),
//     //                       ),
//     //                       _buildShuffleButton(playerProvider)
//     //                     ],
//     //                   ),
//     //                   SizedBox(
//     //                     width: getProportionateScreenWidth(15),
//     //                   ),
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //         );
//     //       },
//     //     ),);

//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Text("Here"),
//       ),
//     );
//   }

// //   Widget _buildAlbumCover(
// //     PodcastPlayer playerProvider,
// //     PodCast podCast,
// //   ) {
// //     return Container(
// //         height: 250,
// //         margin: EdgeInsets.symmetric(
// //             vertical: getProportionateScreenHeight(30),
// //             horizontal: getProportionateScreenWidth(30)),
// //         child: AnimationRotate(
// //           stop: !playerProvider.isPlaying(),
// //           child: SizedBox(
// //             height: 250,
// //             width: 250,
// //             child: ClipRRect(
// //                 borderRadius: BorderRadius.circular(1000),
// //                 child: Stack(
// //                   children: [
// //                     CachedNetworkImage(
// //                       fit: BoxFit.cover,
// //                       imageUrl: playerProvider.getEpisodeCover(),
// //                       height: 250,
// //                       width: 250,
// //                     ),
// //                     Container(
// //                       height: 250,
// //                       width: 250,
// //                       decoration: BoxDecoration(
// //                         //  borderRadius: BorderRadius.circular(1000),
// //                         gradient: LinearGradient(
// //                           begin: Alignment.topCenter,
// //                           end: Alignment.bottomCenter,
// //                           colors: [
// //                             const Color(0xFF343434).withOpacity(0.4),
// //                             const Color(0xFF343434).withOpacity(0.15),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     Align(
// //                       alignment: Alignment.center,
// //                       child: Container(
// //                           height: 75,
// //                           width: 75,
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(1000),
// //                               image: DecorationImage(
// //                                   image: CachedNetworkImageProvider(
// //                                       '$kinAssetBaseUrl/${podCast.cover}'),
// //                                   fit: BoxFit.cover)),
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(1000),
// //                             child: BackdropFilter(
// //                               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   borderRadius: BorderRadius.circular(1000),
// //                                 ),
// //                               ),
// //                             ),
// //                           )),
// //                     ),
// //                     Align(
// //                       alignment: Alignment.center,
// //                       child: Container(
// //                           height: 25,
// //                           width: 25,
// //                           decoration: BoxDecoration(
// //                               borderRadius: BorderRadius.circular(1000),
// //                               image: DecorationImage(
// //                                   image: CachedNetworkImageProvider(
// //                                       '$kinAssetBaseUrl/${podCast.cover}'),
// //                                   fit: BoxFit.cover)),
// //                           child: ClipRRect(
// //                             borderRadius: BorderRadius.circular(1000),
// //                             child: BackdropFilter(
// //                               filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   borderRadius: BorderRadius.circular(1000),
// //                                 ),
// //                               ),
// //                             ),
// //                           )),
// //                     ),
// //                   ],
// //                 )),
// //           ),
// //         ));
// //   }

// //   Widget _buildProgressBar(RealtimePlayingInfos info, PodCastEpisode music,
// //       PodcastPlayer playerProvider) {
// //     return PositionSeekWidget(
// //       currentPosition: info.currentPosition,
// //       duration: //just a dummy time if stream
// //           info.duration,
// //       seekTo: (to) {
// //         playerProvider.player.seek(to);
// //       },
// //     );
// //   }

// //   Widget _buildSongTitle(PodCastEpisode? episode, PodCast podCast) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.stretch,
// //         children: [
// //           Text(
// //             episode!.title,
// //             style: const TextStyle(
// //                 color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
// //           ),
// //           Text(
// //             podCast.narrator,
// //             style: const TextStyle(color: kGrey, fontSize: 16),
// //           )
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildRepeatButton(PodcastPlayer playerProvider) {
// //     return IconButton(
// //       icon: Icon(!playerProvider.loopPlaylist && playerProvider.loopMode
// //           ? Icons.repeat_one
// //           : Icons.repeat),
// //       color: playerProvider.shuffled ? Colors.white : kGrey,
// //       onPressed: () => playerProvider.handleLoop(),
// //     );
// //   }

// //   Widget _buildPreviousButton(PodcastPlayer playerProvider) {
// //     return IconButton(
// //       icon: const Icon(Icons.skip_previous),
// //       color: playerProvider.isFirstEpisode() ? kGrey : Colors.white,
// //       onPressed: () {
// //         playerProvider.prev();
// //       },
// //     );
// //   }

// //   Widget _buildPlayPauseButton(PodcastPlayer playerProvider) {
// //     ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

// //     return PlayerBuilder.isPlaying(
// //         player: playerProvider.player,
// //         builder: (context, isPlaying) {
// //           return InkWell(
// //             onTap: () {
// //               if (isPlaying || playerProvider.player.isBuffering.value) {
// //                 playerProvider.player.pause();
// //               } else {
// //                 if (checkConnection(status)) {
// //                   playerProvider.player.play();
// //                 } else {
// //                   kShowToast();
// //                 }
// //               }
// //             },
// //             child: Container(
// //               width: 50,
// //               height: 50,
// //               padding: const EdgeInsets.all(10),
// //               alignment: Alignment.center,
// //               decoration: BoxDecoration(
// //                   gradient: LinearGradient(
// //                     colors: [kSecondaryColor, kPrimaryColor.withOpacity(0.75)],
// //                   ),
// //                   borderRadius: BorderRadius.circular(1000)),
// //               child: CircleAvatar(
// //                 backgroundColor: Colors.transparent,
// //                 radius: 15,
// //                 child: SvgPicture.asset(
// //                   isPlaying
// //                       ? 'assets/icons/pause.svg'
// //                       : 'assets/icons/play-triangle.svg',
// //                   fit: BoxFit.contain,
// //                   color: Colors.white,
// //                 ),
// //               ),
// //             ),
// //           );
// //         });
// //   }

// //   Widget _buildNextButton(PodcastPlayer playerProvider) {
// //     return IconButton(
// //       icon: const Icon(Icons.skip_next),
// //       color: playerProvider.isLastEpisode(playerProvider.currentIndex! + 1)
// //           ? kGrey
// //           : Colors.white,
// //       onPressed: () {
// //         if (playerProvider.isLastEpisode(playerProvider.currentIndex! + 1)) {
// //           return;
// //         }
// //         playerProvider.next();
// //       },
// //     );
// //   }

// //   Widget _buildShuffleButton(PodcastPlayer playerProvider) {
// //     return IconButton(
// //       icon: const Icon(Icons.shuffle),
// //       color: playerProvider.shuffled ? Colors.white : kGrey,
// //       onPressed: () => playerProvider.handleShuffle(),
// //     );
// //   }
// // }








// // // import 'dart:ui';
// // // import 'package:cached_network_image/cached_network_image.dart';
// // // import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';
// // // import 'package:kin_music_player_app/services/provider/music_player.dart';
// // // import 'package:kin_music_player_app/services/provider/podcast_player.dart';
// // // import 'package:provider/provider.dart';
// // // import 'package:flutter/gestures.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:just_audio/just_audio.dart';
// // // import 'package:flutter_svg/flutter_svg.dart';
// // //
// // // import '../../constants.dart';
// // // import 'package:kin_music_player_app/size_config.dart';
// // // import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// // // import 'package:kin_music_player_app/components/create_playlist.dart';
// // // import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// // // import 'package:kin_music_player_app/services/network/model/music.dart';
// // //
// // // import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
// // //
// // // class NowPlayingPodcast extends StatelessWidget {
// // //   static const String routeName = '/nowPlaying';
// // //   final PodCastEpisode episode;
// // //   final int episodeIndex;
// // //   final int podcastId;
// // //   final String podcastCover;
// // //   final List<PodCastEpisode>? episodes;
// // //   final bool isIndicator;
// // //
// // //   NowPlayingPodcast(
// // //       {Key? key,required this.episode,this.isIndicator = false,required this.podcastCover,required this.episodeIndex ,required this.episodes,required this.podcastId })
// // //       : super(key: key);
// // //
// // //   void getUrl(controlButton, url) async {
// // //     await controlButton.currentPodcastPlayer.setUrl(url);
// // //   }
// // //
// // //   late final AudioPlayer previousMusicPlayer;
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     //if any error change the listen
// // //     final provider = Provider.of<PodcastPlayer>(context,);
// // //     final musicPlayer = Provider.of<MusicPlayer>(context, listen: false);
// // //     provider.currentEpisodeIndex = episodeIndex;
// // //     bool isNewPlaylistMusic = false;
// // //
// // //     musicPlayer.currentMusicPlayer.dispose();
// // //     musicPlayer. pausedIndex = -1;
// // //     musicPlayer.currentMusicId = -1;//1000;
// // //     musicPlayer. currentAlbumId = -1;//1000;
// // //     musicPlayer. currentMusicIndex = -1;
// // //     musicPlayer. isMusicCurrentPlayList = false;
// // //     musicPlayer. previousMusicId = -1;
// // //     musicPlayer. previousAlbumId = -1;
// // //     musicPlayer.controlAudioWave(true);
// // //     musicPlayer.musicChanged = false;
// // //
// // //     if (provider.currentEpisodeIndex != -1 &&
// // //         provider.currentPodcastId != podcastId) {
// // //       provider.currentPodcastPlayer.dispose();
// // //       provider.currentPodcastPlayer = AudioPlayer();
// // //       provider.currentPodcastId = podcastId;
// // //       provider.currentEpisodeId = episodes![provider.currentEpisodeIndex].id;
// // //
// // //       provider.loadPlaylist(
// // //           episodes!
// // //       );
// // //
// // //       provider.setInitialPlaylist(
// // //           episodes!, AudioPlayer(), progressNotifier, podcastId);
// // //
// // //       if (provider.episodeChanged == false) {
// // //         provider.currentPodcastPlayer
// // //             .seek(const Duration(), index: provider.currentEpisodeIndex);
// // //       }
// // //       isNewPlaylistMusic = true;
// // //       provider.controlAudioWave(false);
// // //       provider.play();
// // //       provider.currentEpisode = episodes![provider.currentEpisodeIndex];
// // //       provider.currentPlaylist.clear();
// // //
// // //       for (PodCastEpisode singleEpisode in episodes!) {
// // //         provider.currentPlaylist.add(singleEpisode);
// // //       }
// // //       provider.currentPodcastCover = podcastCover;
// // //     }
// // //
// // //     return WillPopScope(
// // //       onWillPop: (){
// // //         if (!provider.currentPodcastPlayer.playing) {
// // //           provider.pausedIndex = provider.currentEpisodeIndex;
// // //           provider.isBackButtonPressed = true;
// // //         }
// // //         provider.displayCurrentPodcast();
// // //         return Future.value(true);
// // //       },
// // //       child: Scaffold(
// // //         backgroundColor: kPrimaryColor,
// // //         resizeToAvoidBottomInset: false,
// // //         appBar: AppBar(
// // //           title: const Text('Now Playing'),
// // //           elevation: 2,
// // //           leading: BackButton(
// // //             color: Colors.white,
// // //             onPressed: () {
// // //               if (!provider.currentPodcastPlayer.playing) {
// // //                 provider.pausedIndex = provider.currentEpisodeIndex;
// // //                 provider.isBackButtonPressed = true;
// // //               }
// // //               provider.displayCurrentPodcast();
// // //
// // //               Navigator.pop(context);
// // //             },
// // //           ),
// // //           backgroundColor: Colors.transparent,
// // //
// // //         ),
// // //         body: StreamBuilder<SequenceState?>(
// // //           stream: provider.currentPodcastPlayer.sequenceStateStream,
// // //           builder: (context, snapshot) {
// // //             String podcastTitle;
// // //             String? podcastEpisodeCover;
// // //
// // //             bool? isFavorite;
// // //             int? index;
// // //
// // //             if (provider.isEpisodeCurrentPlaylist) {
// // //               // index = provider.isBackButtonPressed
// // //               //     ? episodeIndex
// // //               //     : provider.pausedIndex;
// // //               index = provider.isBackButtonPressed
// // //                   ? episodeIndex
// // //                   : provider.currentPodcastPlayer.currentIndex ??
// // //                   provider.currentEpisodeIndex;
// // //
// // //               provider.currentEpisodeIndex = index;
// // //               provider.isEpisodeCurrentPlaylist = false;
// // //               provider.isBackButtonPressed = false;
// // //             } else {
// // //               index = provider.isBackButtonPressed
// // //                   ? episodeIndex
// // //                   : provider.currentPodcastPlayer.currentIndex ??
// // //                   provider.currentEpisodeIndex;
// // //
// // //             }
// // //
// // //
// // //             podcastTitle = episodes![index].title;
// // //             podcastEpisodeCover = 'https://kinmusic.gamdsolutions.com/$podcastCover';
// // //
// // //
// // //             return Container(
// // //               decoration: BoxDecoration(
// // //                   image: DecorationImage(
// // //                 image: CachedNetworkImageProvider(podcastEpisodeCover), fit: BoxFit.cover)),
// // //               child: BackdropFilter(
// // //                 filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
// // //                 child: Container(
// // //                   color: kPrimaryColor.withOpacity(0.5),
// // //                   child: Column(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       _buildAlbumCover(podcastEpisodeCover),
// // //                       _buildSongTitle(context, podcastTitle, ),
// // //                       SizedBox(
// // //                         height: getProportionateScreenHeight(25),
// // //                       ),
// // //                       _buildProgressBar(context),
// // //                       Row(
// // //                         mainAxisAlignment: MainAxisAlignment.center,
// // //                         children: [
// // //                           _buildRepeatButton(context),
// // //                           SizedBox(
// // //                             width: getProportionateScreenWidth(5),
// // //                           ),
// // //                           _buildPreviousButton(context),
// // //                           SizedBox(
// // //                             width: getProportionateScreenWidth(5),
// // //                           ),
// // //                           _buildPlayButton(
// // //                               episode.audio, context, isNewPlaylistMusic),
// // //                           SizedBox(
// // //                             width: getProportionateScreenWidth(5),
// // //                           ),
// // //                           _buildNextButton(context),
// // //                           SizedBox(
// // //                             width: getProportionateScreenWidth(5),
// // //                           ),
// // //                           _buildShuffleButton(context)
// // //                         ],
// // //                       ),
// // //                       SizedBox(height:getProportionateScreenHeight(50))
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildAlbumCover(String podcastCover) {
// // //     return Container(
// // //       height: getProportionateScreenHeight(275),
// // //       margin: EdgeInsets.symmetric(
// // //           vertical: getProportionateScreenHeight(30),
// // //           horizontal: getProportionateScreenWidth(30)),
// // //       child: ClipRRect(
// // //           borderRadius: BorderRadius.circular(10),
// // //           child:CachedNetworkImage(imageUrl:podcastCover,fit: BoxFit.cover,)),
// // //     );
// // //   }
// // //
// // //   final progressNotifier = ValueNotifier<ProgressBarState>(
// // //     ProgressBarState(
// // //       current: Duration.zero,
// // //       buffered: Duration.zero,
// // //       total: Duration.zero,
// // //     ),
// // //   );
// // //
// // //   Widget _buildProgressBar(context) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //     return Container(
// // //         margin:
// // //         EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
// // //         child: ValueListenableBuilder<ProgressBarState>(
// // //           valueListenable: progressNotifier,
// // //           builder: (_, value, __) {
// // //             return ProgressBar(
// // //               progressBarColor: kSecondaryColor,
// // //               // bufferedBarColor: Colors.white.withOpacity(0.25),
// // //               baseBarColor: kSecondaryColor.withOpacity(0.6),
// // //               timeLabelTextStyle: const TextStyle(color: kGrey, fontSize: 16),
// // //               progress: value.current,
// // //               buffered: value.buffered,
// // //               thumbColor: kSecondaryColor,
// // //               thumbRadius: 10,
// // //               thumbGlowColor: kSecondaryColor.withOpacity(0.5),
// // //               thumbGlowRadius: 15,
// // //               total: value.total,
// // //               onSeek: controlButton.seek,
// // //             );
// // //           },
// // //         ));
// // //   }
// // //
// // //   Widget _buildSongTitle(context, String musicTitle, ) {
// // //     final provider = Provider.of<PodcastPlayer>(context, listen: false);
// // //     return Container(
// // //       margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
// // //       child: Text(
// // //         musicTitle,
// // //         style: const TextStyle(
// // //             color: Colors.white,
// // //             fontSize: 18,
// // //             fontWeight: FontWeight.w700),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildRepeatButton(context) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //
// // //     return ValueListenableBuilder<PodcastRepeatState>(
// // //       valueListenable: controlButton.podcastRepeatNotifier,
// // //       builder: (context, value, child) {
// // //         Icon icon;
// // //         switch (value) {
// // //           case PodcastRepeatState.off:
// // //             icon = const Icon(Icons.repeat, color: Colors.grey);
// // //             break;
// // //           case PodcastRepeatState.podcastRepeatEpisode:
// // //             icon = const Icon(
// // //               Icons.repeat_one,
// // //               color: Colors.white,
// // //             );
// // //             break;
// // //           case PodcastRepeatState.podcastRepeatPlaylist:
// // //             icon = const Icon(
// // //               Icons.repeat,
// // //               color: Colors.white,
// // //             );
// // //             break;
// // //         }
// // //         return IconButton(
// // //           icon: icon,
// // //           onPressed: controlButton.onPodcastRepeatButtonPressed,
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildPreviousButton(context) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //
// // //     return ValueListenableBuilder<bool>(
// // //       valueListenable: controlButton.isFirstSongNotifier,
// // //       builder: (_, isFirst, __) {
// // //         return IconButton(
// // //           icon: const Icon(
// // //             Icons.skip_previous,
// // //             color: Colors.white,
// // //           ),
// // //           onPressed:
// // //           (isFirst) ? null : controlButton.onPreviousSongButtonPressed,
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildPlayButton(audio, context, isNewPlaylistMusic) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //     final currentEpisodeIndex = controlButton.currentEpisodeIndex;
// // //     final AudioPlayer podcastPlayer = AudioPlayer();
// // //
// // //     if (currentEpisodeIndex != -1 && controlButton.currentPodcastId == podcastId) {
// // //       if (controlButton.currentEpisodeId != episodes![currentEpisodeIndex].id) {
// // //         // if any error occur remove this if statement
// // //         if (controlButton.currentPodcastPlayer.currentIndex == episodeIndex) {
// // //           controlButton.currentEpisodeId =
// // //               episodes![controlButton.currentPodcastPlayer.currentIndex!].id;
// // //           controlButton.currentPodcastId = podcastId;
// // //
// // //           controlButton.episodeStateListener(
// // //               '$apiUrl/${episode.audio}',
// // //               podcastPlayer,
// // //               episodes![controlButton.currentPodcastPlayer.currentIndex!].id,
// // //               progressNotifier);
// // //         } else {
// // //           controlButton.currentEpisodeId = episodes![currentEpisodeIndex].id;
// // //           controlButton.currentPodcastId = podcastId;
// // //           if(!isIndicator){
// // //             if (controlButton.episodeChanged == false) {
// // //               controlButton.currentPodcastPlayer
// // //                   .seek(const Duration(), index: episodeIndex);
// // //               // controlButton.currentEpisode = episodes![episodeIndex];
// // //               // controlButton.currentPlaylist.clear();
// // //               //
// // //               // for (PodCastEpisode episode in episodes!) {
// // //               //   controlButton.currentPlaylist.add(episode);
// // //               // }
// // //
// // //               controlButton.controlAudioWave(false);
// // //             }
// // //           }
// // //
// // //
// // //           controlButton.episodeStateListener('$apiUrl/${episode.audio}',
// // //               podcastPlayer, episodes![currentEpisodeIndex].id, progressNotifier);
// // //         }
// // //       } else {
// // //         controlButton.currentEpisodeId = episodes![isNewPlaylistMusic
// // //             ? controlButton.currentPodcastPlayer.currentIndex!
// // //             : controlButton.currentEpisodeIndex]
// // //             .id;
// // //
// // //         controlButton.currentPodcastId = podcastId;
// // //
// // //         controlButton.episodeStateListener(
// // //             '$apiUrl/${episode.audio}',
// // //             podcastPlayer,
// // //             episodes![isNewPlaylistMusic
// // //                 ? controlButton.currentPodcastPlayer.currentIndex!
// // //                 : controlButton.currentEpisodeIndex]
// // //                 .id,
// // //             progressNotifier);
// // //       }
// // //
// // //       if (controlButton.currentPodcastPlayer.playing) {
// // //         controlButton.currentEpisodeIndex =
// // //         controlButton.currentPodcastPlayer.currentIndex!;
// // //       } else {}
// // //       controlButton.episodeChanged = false;
// // //     } else {
// // //       if (controlButton.currentEpisodeId != episode.id) {
// // //         if (controlButton.currentEpisodeId != -1) {
// // //           controlButton.pause();
// // //           controlButton.currentPodcastPlayer = podcastPlayer;
// // //           controlButton.currentEpisodeId = episode.id;
// // //           controlButton.currentPodcastId = podcastId;
// // //           getUrl(controlButton, '$apiUrl/${episode.audio}');
// // //           controlButton.episodeStateListener('$apiUrl/${episode.audio}',
// // //               podcastPlayer, episode.id, progressNotifier);
// // //
// // //           controlButton.currentEpisode = episode;
// // //           controlButton.currentPlaylist.clear();
// // //
// // //           controlButton.currentPlaylist.add(episode);
// // //           controlButton.currentPodcastCover = podcastCover;
// // //
// // //           controlButton.controlAudioWave(false);
// // //
// // //           controlButton.play();
// // //         } else {
// // //           controlButton.episodeStateListener('$apiUrl/${episode.audio}',
// // //               podcastPlayer, episode.id, progressNotifier);
// // //         }
// // //       } else {
// // //         controlButton.episodeStateListener(
// // //             '$apiUrl/${episode.audio}', podcastPlayer, episode.id, progressNotifier);
// // //       }
// // //     }
// // //
// // //     return ValueListenableBuilder<PodcastButtonState>(
// // //       valueListenable: controlButton.podcastButtonNotifier,
// // //       builder: (_, value, __) {
// // //         switch (value) {
// // //           case PodcastButtonState.loading:
// // //             return Container(
// // //               margin: const EdgeInsets.all(8.0),
// // //               width: 32.0,
// // //               height: 32.0,
// // //               child: const CircularProgressIndicator(),
// // //             );
// // //           case PodcastButtonState.paused:
// // //             return GestureDetector(
// // //               onTap: () async {
// // //                 if (currentEpisodeIndex == -1) {
// // //                   if (controlButton.currentEpisodeId == episode.id) {
// // //                     controlButton.play();
// // //                   } else {
// // //
// // //                     controlButton.currentPodcastPlayer = podcastPlayer;
// // //                     controlButton.currentEpisodeId = episode.id;
// // //                     controlButton.currentPodcastId = podcastId;
// // //                     getUrl(controlButton, '$apiUrl/${episode.audio}');
// // //                     controlButton.currentEpisode = episode;
// // //
// // //                     controlButton.currentPlaylist.clear();
// // //                     controlButton.currentPlaylist.add(episode);
// // //                     controlButton.currentPodcastCover = podcastCover;
// // //
// // //                     controlButton.controlAudioWave(false);
// // //                     controlButton.play();
// // //                   }
// // //                 } else {
// // //                   if (controlButton.previousPodcastId ==
// // //                       controlButton.currentPodcastId &&
// // //                       controlButton.previousEpisodeId ==
// // //                           controlButton.currentEpisodeId) {
// // //                     controlButton.play();
// // //                     controlButton.pausedIndex =
// // //                     controlButton.currentPodcastPlayer.currentIndex!;
// // //                     controlButton.currentEpisodeId =
// // //                         episodes![controlButton.currentPodcastPlayer.currentIndex!]
// // //                             .id;
// // //                     controlButton.currentEpisodeIndex =
// // //                     controlButton.currentPodcastPlayer.currentIndex!;
// // //                     controlButton.currentPodcastId = podcastId;
// // //                     controlButton.episodeStateListener(
// // //                         '$apiUrl/${episode.audio}',
// // //                         podcastPlayer,
// // //                         episodes![controlButton.currentEpisodeIndex].id,
// // //                         progressNotifier);
// // //                     controlButton.controlAudioWave(false);
// // //                   } else {
// // //                     // controlButton.episodeChanged = false;
// // //
// // //                     if (controlButton.episodeChanged == false) {
// // //                       controlButton.currentPodcastPlayer.seek(const Duration(),
// // //                           index: controlButton.isBackButtonPressed
// // //                               ? episodeIndex
// // //                               : controlButton.pausedIndex);
// // //
// // //                       controlButton.currentEpisode = episodes![
// // //                       controlButton.currentPodcastPlayer.currentIndex!];
// // //
// // // if(!isIndicator){
// // //   controlButton.currentPlaylist.clear();
// // //   for (PodCastEpisode episode in episodes!) {
// // //     controlButton.currentPlaylist.add(episode);
// // //   }
// // // }
// // //
// // //                       controlButton.currentPodcastCover = podcastCover;
// // //
// // //                       controlButton.controlAudioWave(false);
// // //                     } else {
// // //                       controlButton.currentEpisode = episodes![
// // //                       controlButton.currentPodcastPlayer.currentIndex!];
// // //                       controlButton.currentPlaylist.clear();
// // //
// // //                       for (PodCastEpisode episode in episodes!) {
// // //                         controlButton.currentPlaylist.add(episode);
// // //                       }
// // //                       controlButton.currentPodcastCover = podcastCover;
// // //                       controlButton.controlAudioWave(false);
// // //                     }
// // //                     controlButton.play();
// // //                     controlButton.currentPodcastId = podcastId;
// // //                     controlButton.currentEpisodeIndex =
// // //                     controlButton.currentPodcastPlayer.currentIndex!;
// // //                     controlButton.currentEpisodeId =
// // //                         episodes![controlButton.currentPodcastPlayer.currentIndex!]
// // //                             .id;
// // //                     controlButton.episodeStateListener(
// // //                         '$apiUrl/${episode.audio}',
// // //                         podcastPlayer,
// // //                         episodes![controlButton.currentPodcastPlayer.currentIndex!]
// // //                             .id,
// // //                         progressNotifier);
// // //
// // //                     controlButton.episodeChanged = false;
// // //                   }
// // //                   controlButton.isEpisodeCurrentPlaylist = true;
// // //                 }
// // //               },
// // //               child: Container(
// // //                 width: 50,
// // //                 height: 50,
// // //                 padding: const EdgeInsets.all(10),
// // //                 alignment: Alignment.center,
// // //                 decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         kSecondaryColor,
// // //                         kPrimaryColor.withOpacity(0.75)
// // //                       ],
// // //                     ),
// // //                     borderRadius: BorderRadius.circular(1000)),
// // //                 child: CircleAvatar(
// // //                   backgroundColor: Colors.transparent,
// // //                   radius: 15,
// // //                   child: SvgPicture.asset(
// // //                     'assets/icons/play-triangle.svg',
// // //                     fit: BoxFit.contain,
// // //                     color: Colors.white,
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //           case PodcastButtonState.playing:
// // //             return GestureDetector(
// // //               onTap: () {
// // //
// // //                 if (controlButton.currentEpisodeIndex == -1 && podcastId == -1) {
// // //                   controlButton.pause();
// // //                   controlButton.controlAudioWave(true);
// // //                 } else {
// // //                   controlButton.previousEpisodeId =
// // //                       episodes![controlButton.currentPodcastPlayer.currentIndex!]
// // //                           .id;
// // //                   controlButton.previousPodcastId = podcastId;
// // //                   controlButton.episodeStateListener(
// // //                       '$apiUrl/${episode.audio}',
// // //                       podcastPlayer,
// // //                       episodes![controlButton.currentPodcastPlayer
// // //                           .currentIndex!]
// // //                           .id,
// // //                       progressNotifier);
// // //                   controlButton.pause();
// // //                   controlButton.controlAudioWave(true);
// // //                 }
// // //               },
// // //               child: Container(
// // //                 width: 50,
// // //                 height: 50,
// // //                 padding: const EdgeInsets.all(10),
// // //                 alignment: Alignment.center,
// // //                 decoration: BoxDecoration(
// // //                     gradient: LinearGradient(
// // //                       colors: [
// // //                         kSecondaryColor,
// // //                         kPrimaryColor.withOpacity(0.75)
// // //                       ],
// // //                     ),
// // //                     borderRadius: BorderRadius.circular(1000)),
// // //                 child: CircleAvatar(
// // //                   backgroundColor: Colors.transparent,
// // //                   radius: 15,
// // //                   child: SvgPicture.asset(
// // //                     'assets/icons/pause.svg',
// // //                     fit: BoxFit.contain,
// // //                     color: Colors.white,
// // //                   ),
// // //                 ),
// // //               ),
// // //             );
// // //         }
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildNextButton(context) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //     return ValueListenableBuilder<bool>(
// // //       valueListenable: controlButton.isLastSongNotifier,
// // //       builder: (_, isLast, __) {
// // //         return IconButton(
// // //           icon: const Icon(
// // //             Icons.skip_next,
// // //             color: Colors.white,
// // //           ),
// // //           onPressed: (isLast) ? null : controlButton.onNextSongButtonPressed,
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildShuffleButton(context) {
// // //     final controlButton = Provider.of<PodcastPlayer>(context);
// // //     return ValueListenableBuilder<bool>(
// // //       valueListenable: controlButton.isShuffleModeEnabledNotifier,
// // //       builder: (context, isEnabled, child) {
// // //         return IconButton(
// // //           icon: (isEnabled)
// // //               ? const Icon(
// // //             Icons.shuffle,
// // //             color: Colors.white,
// // //           )
// // //               : const Icon(Icons.shuffle, color: Colors.grey),
// // //           onPressed: () {
// // //             isEnabled = !isEnabled;
// // //            E
// // //             controlButton.isShuffleModeEnabledNotifier;
// // //           },
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Widget _buildScrollableLyrics(BuildContext context, lyrics) {
// // //     return GestureDetector(
// // //       dragStartBehavior: DragStartBehavior.start,
// // //       onVerticalDragStart: (DragStartDetails dragStartDetails) {
// // //         showMaterialModalBottomSheet(
// // //           context: context,
// // //           builder: (context) => SizedBox(
// // //             height: MediaQuery.of(context).size.height * 0.75,
// // //             width: double.infinity,
// // //             child: BackdropFilter(
// // //               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
// // //               child: Container(
// // //                 alignment: Alignment.topCenter,
// // //                 decoration: BoxDecoration(
// // //                   color: kGrey.withOpacity(0.2),
// // //                   borderRadius: const BorderRadius.only(
// // //                     topLeft: Radius.circular(50),
// // //                     topRight: Radius.circular(50),
// // //                   ),
// // //                 ),
// // //                 child: SingleChildScrollView(
// // //                   padding: EdgeInsets.only(
// // //                       top: getProportionateScreenHeight(50),
// // //                       left: getProportionateScreenWidth(100)),
// // //                   child: SizedBox(
// // //                       width: double.infinity,
// // //                       child: Text(
// // //                         lyrics,
// // //                         style: const TextStyle(color: Colors.white),
// // //                       )),
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //       child: Container(
// // //         height: 70,
// // //         decoration: BoxDecoration(
// // //           color: kGrey.withOpacity(0.15),
// // //           borderRadius: const BorderRadius.only(
// // //               topLeft: Radius.circular(50), topRight: Radius.circular(50)),
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.stretch,
// // //           mainAxisAlignment: MainAxisAlignment.spaceAround,
// // //           children: const [
// // //             Icon(
// // //               Icons.expand_less,
// // //               color: kSecondaryColor,
// // //             ),
// // //             Center(
// // //               child: Text(
// // //                 'Lyrics',
// // //                 style: TextStyle(color: Colors.white),
// // //               ),
// // //             )
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }