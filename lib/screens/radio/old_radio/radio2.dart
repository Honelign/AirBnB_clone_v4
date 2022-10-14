import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/kin_audio_wave.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class RadioScreen1 extends StatefulWidget {
  const RadioScreen1({Key? key}) : super(key: key);

  @override
  State<RadioScreen1> createState() => _RadioScreen1State();
}

class _RadioScreen1State extends State<RadioScreen1> {
  int index = 0;
  bool isLoading = false;
  bool isPlaying = false;
  List<RadioStation>? stations;
  var future;
  @override
  void initState() {
    loadStations();
    future = context.read<RadioProvider>().getStations();

    super.initState();
  }

  void loadStations() async {
    stations = await context.read<RadioProvider>().getStations();
  }

  @override
  Widget build(BuildContext context) {
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicPlayer>(
      context,
    );
    final RadioProvider radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'Radio',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, AsyncSnapshot snapshot) {
          if (!(snapshot.connectionState == ConnectionState.waiting)) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                  onRefresh: () async {
                    loadStations();
                    setState(() {});
                  },
                  backgroundColor: refreshIndicatorBackgroundColor,
                  color: refreshIndicatorForegroundColor,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    /*  decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  '$kinAssetBaseUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
                          // color: Colors.red,
                        ), */
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    kPrimaryColor.withOpacity(0.5),
                                    kPrimaryColor
                                  ],
                                ),
                              ),
                            ),
                            Consumer<RadioProvider>(
                                builder: (context, radioP, _) {
                              if (radioP.isLoading) {
                                return Container(
                                  color: Colors.transparent,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3),
                                        child: Center(
                                          child: Container(
                                            color: Colors.transparent,
                                            child: SpinKitFadingCircle(
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    color: index.isEven
                                                        ? kSecondaryColor
                                                        : Colors.white,
                                                  ),
                                                );
                                              },
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (radioP.stations.isNotEmpty) {
                                return Center(
                                  child: ListView.builder(
                                      itemCount: radioP.stations.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  spreadRadius: -4,
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                  blurRadius: 13,
                                                )
                                              ]),
                                          height: 60,
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (checkConnection(status)) {
                                                podcastProvider.player.stop();
                                                musicProvider.player.stop();

                                                musicProvider
                                                    .setMusicStopped(true);
                                                podcastProvider
                                                    .setEpisodeStopped(true);

                                                musicProvider
                                                    .listenMusicStreaming();
                                                podcastProvider
                                                    .listenPodcastStreaming();
                                                radioProvider.setPlayer(
                                                    radioProvider.player,
                                                    musicProvider,
                                                    podcastProvider);
                                                radioProvider.play(index);
                                              } else {
                                                kShowToast();
                                              }
                                            },
                                            //https://storage.googleapis.com/kin-project-352614-kinmusic-storage/https://storage.googleapis.com/kin-project-352614-kinmusic-storage/Media_Files/Station_Cover_Images/hone_the_office.jpg
                                            //https://storage.googleapis.com/kin-project-352614-kinmusic-storage/Media_Files/Station_Cover_Images/hone_the_office.jpg
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Card(
                                                      elevation: 25,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                '${radioProvider.stations[index].coverImage}',
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              height: 60,
                                                              width: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          radioProvider
                                                              .stations[index]
                                                              .stationName,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white70,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .baseline,
                                                          textBaseline:
                                                              TextBaseline
                                                                  .alphabetic,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              stations![index]
                                                                  .mhz
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                            const Text(
                                                              'mhz',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white70,
                                                                fontSize: 16,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                radioP.currentStation == null
                                                    ? Container()
                                                    : !radioP.isStationLoaded &&
                                                            radioP.tIndex ==
                                                                radioP
                                                                    .currentIndex
                                                        ? SizedBox(
                                                            height: 30,
                                                            width: 20,
                                                            child:
                                                                SpinKitFadingCircle(
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return DecoratedBox(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: index
                                                                            .isEven
                                                                        ? kSecondaryColor
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                );
                                                              },
                                                              size: 30,
                                                            ),
                                                          )
                                                        : radioP.currentStation!
                                                                        .id ==
                                                                    radioP
                                                                        .stations[
                                                                            index]
                                                                        .id &&
                                                                radioP
                                                                    .isStationLoaded
                                                            ? radioP.isStationInProgress(
                                                                    stations![
                                                                        index])
                                                                ? const KinPlayingAudioWave()
                                                                : const KinPausedAudioWave()
                                                            : Container()
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return Container(
                                  color: Colors.transparent,
                                  height: MediaQuery.of(context).size.height,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3),
                                        child: const Center(
                                          child: Text(
                                            'Pull to refresh',
                                            style: TextStyle(color: kGrey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ));
            } else if (snapshot.hasError) {
              return Container(
                color: Colors.red,
                child: Text('No Internet Connection',
                    style: TextStyle(color: Colors.white)),
              );
            }
            return const Center(
              child: Text(
                'No Data',
                style: TextStyle(color: kGrey),
              ),
            );
          }
          return const Center(
            child: KinProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildNextButton(RadioProvider radioProvider,
      MusicPlayer musicProvider, PodcastPlayer podcastProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return GestureDetector(
      child: Container(
        color: Colors.transparent,
        child: Icon(
          Icons.skip_next,
          size: 40,
          color: radioProvider.isLastStation(radioProvider.currentIndex + 1)
              ? kGrey
              : Colors.white,
        ),
      ),
      onTap: () {
        if (!radioProvider.isLastStation(radioProvider.currentIndex + 1)) {
          if (checkConnection(status)) {
            podcastProvider.player.stop();
            musicProvider.player.stop();

            musicProvider.setMusicStopped(true);
            podcastProvider.setEpisodeStopped(true);

            musicProvider.listenMusicStreaming();
            podcastProvider.listenPodcastStreaming();
            radioProvider.setPlayer(
                radioProvider.player, musicProvider, podcastProvider);
            radioProvider.next();
          } else {
            kShowToast();
          }
        }
      },
    );
  }

  Widget _buildPreviousButton(RadioProvider radioProvider,
      MusicPlayer musicProvider, PodcastPlayer podcastProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return GestureDetector(
      child: Container(
        child: Icon(
          Icons.skip_previous,
          size: 40,
          color: radioProvider.isFirstStation() ? kGrey : Colors.white,
        ),
        color: Colors.transparent,
      ),
      onTap: () {
        if (checkConnection(status)) {
          podcastProvider.player.stop();
          musicProvider.player.stop();

          musicProvider.setMusicStopped(true);
          podcastProvider.setEpisodeStopped(true);

          musicProvider.listenMusicStreaming();
          podcastProvider.listenPodcastStreaming();

          radioProvider.setPlayer(
              radioProvider.player, musicProvider, podcastProvider);
          radioProvider.prev();
        } else {
          kShowToast();
        }
      },
    );
  }

  Widget _buildPlayButton(
      RadioProvider radioProvider,
      PodcastPlayer podcastProvider,
      MusicPlayer musicProvider,
      bool isPlaying) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return InkWell(
      onTap: () {
        if (!radioProvider.isPlaying) {
          if (checkConnection(status)) {
            podcastProvider.player.stop();
            musicProvider.player.stop();

            musicProvider.setMusicStopped(true);
            podcastProvider.setEpisodeStopped(true);

            musicProvider.listenMusicStreaming();
            podcastProvider.listenPodcastStreaming();
            radioProvider.setPlayer(
                radioProvider.player, musicProvider, podcastProvider);
            radioProvider.handlePlayButton(radioProvider.currentIndex);
            radioProvider.setIsPlaying(true);
          } else {
            kShowToast();
          }
        } else {
          radioProvider.player.pause();
          radioProvider.setIsPlaying(false);
        }
      },
      child: Card(
        elevation: 50,
        color: Colors.transparent,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
        child: Container(
          width: 90,
          height: 90,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kSecondaryColor, kPrimaryColor.withOpacity(0.75)],
              ),
              borderRadius: BorderRadius.circular(1000)),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 50,
            child: !radioProvider.isStationLoaded
                ? SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? kSecondaryColor : Colors.white,
                        ),
                      );
                    },
                    size: 30,
                  )
                : SvgPicture.asset(
                    isPlaying
                        ? 'assets/icons/pause.svg'
                        : 'assets/icons/on-off-button.svg',
                    fit: BoxFit.contain,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}

//
// stations == null ? ListView(
// children: [
// Padding(
// padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
// child: const Center(
// child: Text(
// 'No Internet',
// textAlign: TextAlign.center,
// style: TextStyle(color: kGrey),
// ),
// ),
// ),
// ],
// ): FutureBuilder(
// future: context.read<RadioProvider>().getStations(),
// builder: (context, AsyncSnapshot<List<RadioStation>> snapshot) {
// if (!(snapshot.connectionState == ConnectionState.waiting)) {
// if (snapshot.hasData) {
// return PlayerBuilder.isPlaying(
// player: radioProvider.player,
// builder: (context, playing) {
// return ListView.builder(itemCount: stations!.length,itemBuilder: (context,index){
// return ListTile(
// onTap: (){
// if (!radioProvider.isLastStation(radioProvider.currentIndex + 1)) {
//
// if (checkConnection(status)) {
// podcastProvider.player.stop();
// musicProvider.player.stop();
//
// musicProvider.setMusicStopped(true);
// podcastProvider.setEpisodeStopped(true);
//
// musicProvider.listenMusicStreaming();
// podcastProvider.listenPodcastStreaming();
// radioProvider.setPlayer(
// radioProvider.player, musicProvider, podcastProvider);
// radioProvider.next();
//
// } else {
// kShowToast();
// }
// }
// },
// leading: Card(
// elevation: 25,
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(30)),
// child: Stack(
// children: [
// Container(
// height: 100,
// width: 100,
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.circular(25),
// image: DecorationImage(
// image: CachedNetworkImageProvider(
// '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
// ),
// ),
// Container(
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.circular(25),
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [
// kPrimaryColor
//     .withOpacity(0.4),
// kPrimaryColor
//     .withOpacity(0.1),
// kPrimaryColor.withOpacity(0.4)
// ],
// ),
// ),
// )
// ],
// ),
// ), title:                                     Row(
// crossAxisAlignment:
// CrossAxisAlignment.baseline,
// textBaseline: TextBaseline.alphabetic,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// radioProvider
//     .stations[
// radioProvider.currentIndex]
//     .mhz,
// style: const TextStyle(
// color: Colors.white70,
// fontSize: 35,
// fontWeight: FontWeight.w900),
// ),
// const Text(
// 'mhz',
// style: TextStyle(
// color: Colors.white70,
// fontSize: 16,
// fontStyle: FontStyle.italic),
// ),
// ],
// ),
// subtitle:                                Text(
// stations![index].stationName,
// style:const  TextStyle(
// color: Colors.white70,
// fontSize: 16,
// fontStyle: FontStyle.italic),
// ),
// );
// });
// // return
// //   Container(
// //   height: MediaQuery.of(context).size.height,
// //   width: double.infinity,
// //   decoration: BoxDecoration(
// //     image: DecorationImage(
// //         fit: BoxFit.fill,
// //         image: CachedNetworkImageProvider(
// //             '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
// //     // color: Colors.red,
// //   ),
// //   child: BackdropFilter(
// //     filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
// //     child: Stack(
// //       children: [
// //         Container(
// //           decoration: BoxDecoration(
// //             gradient: LinearGradient(
// //               begin: Alignment.topCenter,
// //               end: Alignment.bottomCenter,
// //               colors: [
// //                 kPrimaryColor.withOpacity(0.3),
// //                 kPrimaryColor
// //               ],
// //             ),
// //           ),
// //         ),
// //         Column(
// //           // crossAxisAlignment: CrossAxisAlignment.stretch,
// //
// //           children: [
// //             SizedBox(
// //               height: getProportionateScreenHeight(50),
// //             ),
// //             SizedBox(
// //               height: 200,
// //               width: 200,
// //               child: Card(
// //                 elevation: 25,
// //                 shape: RoundedRectangleBorder(
// //                     borderRadius:
// //                         BorderRadius.circular(30)),
// //                 child: Stack(
// //                   children: [
// //                     Container(
// //                       height: 200,
// //                       width: 200,
// //                       decoration: BoxDecoration(
// //                         borderRadius:
// //                             BorderRadius.circular(25),
// //                         image: DecorationImage(
// //                             image: CachedNetworkImageProvider(
// //                                 '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
// //                       ),
// //                     ),
// //                     Container(
// //                       decoration: BoxDecoration(
// //                         borderRadius:
// //                             BorderRadius.circular(25),
// //                         gradient: LinearGradient(
// //                           begin: Alignment.topCenter,
// //                           end: Alignment.bottomCenter,
// //                           colors: [
// //                             kPrimaryColor
// //                                 .withOpacity(0.4),
// //                             kPrimaryColor
// //                                 .withOpacity(0.1),
// //                             kPrimaryColor.withOpacity(0.4)
// //                           ],
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               height: getProportionateScreenHeight(25),
// //             ),
// //             Row(
// //               crossAxisAlignment:
// //                   CrossAxisAlignment.baseline,
// //               textBaseline: TextBaseline.alphabetic,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   radioProvider
// //                       .stations[
// //                           radioProvider.currentIndex]
// //                       .mhz,
// //                   style: const TextStyle(
// //                       color: Colors.white70,
// //                       fontSize: 35,
// //                       fontWeight: FontWeight.w900),
// //                 ),
// //                 const Text(
// //                   'mhz',
// //                   style: TextStyle(
// //                       color: Colors.white70,
// //                       fontSize: 16,
// //                       fontStyle: FontStyle.italic),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(
// //               height: getProportionateScreenHeight(50),
// //             ),
// //             Row(
// //               // crossAxisAlignment: CrossAxisAlignment.end,
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 _buildPreviousButton(radioProvider,
// //                     musicProvider, podcastProvider),
// //                 SizedBox(
// //                   width: getProportionateScreenWidth(50),
// //                 ),
// //                 _buildPlayButton(
// //                     radioProvider,
// //                     podcastProvider,
// //                     musicProvider,
// //                     playing),
// //                 SizedBox(
// //                   width: getProportionateScreenWidth(50),
// //                 ),
// //                 _buildNextButton(radioProvider,
// //                     musicProvider, podcastProvider)
// //               ],
// //             )
// //           ],
// //         ),
// //       ],
// //     ),
// //   ),
// // );
// });

//
// import 'dart:ui';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
// import 'package:kin_music_player_app/constants.dart';
// import 'package:kin_music_player_app/services/connectivity_result.dart';
// import 'package:kin_music_player_app/services/provider/music_player.dart';
// import 'package:kin_music_player_app/services/provider/podcast_player.dart';
// import 'package:kin_music_player_app/services/provider/radio_provider.dart';
// import 'package:kin_music_player_app/size_config.dart';
// import 'package:provider/provider.dart';
//
// class RadioScreen extends StatefulWidget {
//   const RadioScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RadioScreen> createState() => _RadioScreenState();
// }
//
// class _RadioScreenState extends State<RadioScreen> {
//   int index = 0;
//   bool isLoading = false;
//   bool isPlaying = false;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var podcastProvider = Provider.of<PodcastPlayer>(
//       context,
//     );
//     var musicProvider = Provider.of<MusicPlayer>(
//       context,
//     );
//     final RadioProvider radioProvider = Provider.of<RadioProvider>(
//       context,
//     );
//     final RadioProvider provider = Provider.of<RadioProvider>(
//         context,listen: false
//     );
//     return Scaffold(
//         backgroundColor: kPrimaryColor,
//         appBar: AppBar(
//           title: const Text('Radio'),
//           backgroundColor: Colors.transparent,
//         ),
//         body: RefreshIndicator(
//             color: kSecondaryColor,
//             onRefresh: () async {
//               setState(() {});
//             },
//             child: FutureBuilder(
//                 future: radioProvider.getStations(),
//                 builder: (context, AsyncSnapshot snapshot) {
//
//                   if (provider.isLoading &&
//                       snapshot.connectionState == ConnectionState.waiting) {
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
//
//                           child: KinProgressIndicator(),
//                         )
//                       ],
//                     );
//                   }   else if (provider.isLoading &&
//                       !(snapshot.connectionState == ConnectionState.active)) {
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
//
//                           child: Text(
//                             "No Internet",
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7)),
//                           ),
//                         )
//                       ],
//                     );
//                   }else if (snapshot.hasData &&
//                       snapshot.connectionState == ConnectionState.done) {
//                     return PlayerBuilder.isPlaying(
//                         player: radioProvider.player,
//                         builder: (context, playing) {
//                           return Container(
//                             height: MediaQuery.of(context).size.height,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   fit: BoxFit.fill,
//                                   image: CachedNetworkImageProvider(
//                                       '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
//                               // color: Colors.red,
//                             ),
//                             child: BackdropFilter(
//                               filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
//                               child: Stack(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           kPrimaryColor.withOpacity(0.3),
//                                           kPrimaryColor
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     // crossAxisAlignment: CrossAxisAlignment.stretch,
//
//                                     children: [
//                                       SizedBox(
//                                         height: getProportionateScreenHeight(50),
//                                       ),
//                                       SizedBox(
//                                         height: 200,
//                                         width: 200,
//                                         child: Card(
//                                           elevation: 25,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                               BorderRadius.circular(30)),
//                                           child: Stack(
//                                             children: [
//                                               Container(
//                                                 height: 200,
//                                                 width: 200,
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius.circular(25),
//                                                   image: DecorationImage(
//                                                       image: CachedNetworkImageProvider(
//                                                           '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
//                                                 ),
//                                               ),
//                                               Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                   BorderRadius.circular(25),
//                                                   gradient: LinearGradient(
//                                                     begin: Alignment.topCenter,
//                                                     end: Alignment.bottomCenter,
//                                                     colors: [
//                                                       kPrimaryColor
//                                                           .withOpacity(0.4),
//                                                       kPrimaryColor
//                                                           .withOpacity(0.1),
//                                                       kPrimaryColor.withOpacity(0.4)
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: getProportionateScreenHeight(25),
//                                       ),
//                                       Row(
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.baseline,
//                                         textBaseline: TextBaseline.alphabetic,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             radioProvider
//                                                 .stations[
//                                             radioProvider.currentIndex]
//                                                 .mhz,
//                                             style: const TextStyle(
//                                                 color: Colors.white70,
//                                                 fontSize: 35,
//                                                 fontWeight: FontWeight.w900),
//                                           ),
//                                           const Text(
//                                             'mhz',
//                                             style: TextStyle(
//                                                 color: Colors.white70,
//                                                 fontSize: 16,
//                                                 fontStyle: FontStyle.italic),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(
//                                         height: getProportionateScreenHeight(50),
//                                       ),
//                                       Row(
//                                         // crossAxisAlignment: CrossAxisAlignment.end,
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           _buildPreviousButton(radioProvider,
//                                               musicProvider, podcastProvider),
//                                           SizedBox(
//                                             width: getProportionateScreenWidth(50),
//                                           ),
//                                           _buildPlayButton(
//                                               radioProvider,
//                                               podcastProvider,
//                                               musicProvider,
//                                               playing),
//                                           SizedBox(
//                                             width: getProportionateScreenWidth(50),
//                                           ),
//                                           _buildNextButton(radioProvider,
//                                               musicProvider, podcastProvider)
//                                         ],
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         });
//                   } else if (!snapshot.hasData &&
//                       snapshot.connectionState == ConnectionState.active) {
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
//
//                           child: Text(
//                             "No Data",
//                             style: TextStyle(
//                                 color: Colors.white.withOpacity(0.7)),
//                           ),
//                         )
//                       ],
//                     );
//                   }
//                   return ListView(
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//                       Container(
//                         padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.45),
//
//                         child: KinProgressIndicator(),
//                       )
//                     ],
//                   );
//
//
//                 })
//
//         ));
//   }
//
//   Widget _buildNextButton(RadioProvider radioProvider,
//       MusicPlayer musicProvider, PodcastPlayer podcastProvider) {
//     ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
//
//     return GestureDetector(
//       child: Container(
//         color: Colors.transparent,
//         child: Icon(
//           Icons.skip_next,
//           size: 40,
//           color: radioProvider.isLastStation(radioProvider.currentIndex + 1)
//               ? kGrey
//               : Colors.white,
//         ),
//       ),
//       onTap: () {
//         if (!radioProvider.isLastStation(radioProvider.currentIndex + 1)) {
//
//           if (checkConnection(status)) {
//             podcastProvider.player.stop();
//             musicProvider.player.stop();
//
//             musicProvider.setMusicStopped(true);
//             podcastProvider.setEpisodeStopped(true);
//
//             musicProvider.listenMusicStreaming();
//             podcastProvider.listenPodcastStreaming();
//             radioProvider.setPlayer(
//                 radioProvider.player, musicProvider, podcastProvider);
//             radioProvider.next();
//
//           } else {
//             kShowToast();
//           }
//         }
//       },
//     );
//   }
//
//   Widget _buildPreviousButton(RadioProvider radioProvider,
//       MusicPlayer musicProvider, PodcastPlayer podcastProvider) {
//     ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
//
//     return GestureDetector(
//       child: Container(
//         child: Icon(
//           Icons.skip_previous,
//           size: 40,
//           color: radioProvider.isFirstStation() ? kGrey : Colors.white,
//         ),
//         color: Colors.transparent,
//       ),
//       onTap: () {
//
//         if (checkConnection(status)) {
//           podcastProvider.player.stop();
//           musicProvider.player.stop();
//
//           musicProvider.setMusicStopped(true);
//           podcastProvider.setEpisodeStopped(true);
//
//           musicProvider.listenMusicStreaming();
//           podcastProvider.listenPodcastStreaming();
//
//           radioProvider.setPlayer(
//               radioProvider.player, musicProvider, podcastProvider);
//           radioProvider.prev();
//         } else {
//           kShowToast();
//         }
//       },
//     );
//   }
//
//   Widget _buildPlayButton(
//       RadioProvider radioProvider,
//       PodcastPlayer podcastProvider,
//       MusicPlayer musicProvider,
//       bool isPlaying) {
//     ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
//
//     return InkWell(
//       onTap: () {
//
//
//         if (!radioProvider.isPlaying) {
//           if (checkConnection(status)) {
//             podcastProvider.player.stop();
//             musicProvider.player.stop();
//
//             musicProvider.setMusicStopped(true);
//             podcastProvider.setEpisodeStopped(true);
//
//             musicProvider.listenMusicStreaming();
//             podcastProvider.listenPodcastStreaming();
//             radioProvider.setPlayer(
//                 radioProvider.player, musicProvider, podcastProvider);
//             radioProvider.handlePlayButton(radioProvider.currentIndex);
//             radioProvider.setIsPlaying(true);
//           } else {
//             kShowToast();
//           }
//         } else {
//           radioProvider.player.pause();
//           radioProvider.setIsPlaying(false);
//         }
//       },
//       child: Card(
//         elevation: 50,
//         color: Colors.transparent,
//         shape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
//         child: Container(
//           width: 90,
//           height: 90,
//           padding: const EdgeInsets.all(20),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [kSecondaryColor, kPrimaryColor.withOpacity(0.75)],
//               ),
//               borderRadius: BorderRadius.circular(1000)),
//           child: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: 50,
//             child: !radioProvider.isStationLoaded
//                 ? SpinKitFadingCircle(
//               itemBuilder: (BuildContext context, int index) {
//                 return DecoratedBox(
//                   decoration: BoxDecoration(
//                     color: index.isEven ? kSecondaryColor : Colors.white,
//                   ),
//                 );
//               },
//               size: 30,
//             )
//                 : SvgPicture.asset(
//               isPlaying
//                   ? 'assets/icons/pause.svg'
//                   : 'assets/icons/on-off-button.svg',
//               fit: BoxFit.contain,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// //
// // if (!(snapshot.connectionState == ConnectionState.waiting)) {
// // if (snapshot.hasData) {
// // return PlayerBuilder.isPlaying(
// // player: radioProvider.player,
// // builder: (context, playing) {
// // return Container(
// // height: MediaQuery.of(context).size.height,
// // width: double.infinity,
// // decoration: BoxDecoration(
// // image: DecorationImage(
// // fit: BoxFit.fill,
// // image: CachedNetworkImageProvider(
// // '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
// // // color: Colors.red,
// // ),
// // child: BackdropFilter(
// // filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
// // child: Stack(
// // children: [
// // Container(
// // decoration: BoxDecoration(
// // gradient: LinearGradient(
// // begin: Alignment.topCenter,
// // end: Alignment.bottomCenter,
// // colors: [
// // kPrimaryColor.withOpacity(0.3),
// // kPrimaryColor
// // ],
// // ),
// // ),
// // ),
// // Column(
// // // crossAxisAlignment: CrossAxisAlignment.stretch,
// //
// // children: [
// // SizedBox(
// // height: getProportionateScreenHeight(50),
// // ),
// // SizedBox(
// // height: 200,
// // width: 200,
// // child: Card(
// // elevation: 25,
// // shape: RoundedRectangleBorder(
// // borderRadius:
// // BorderRadius.circular(30)),
// // child: Stack(
// // children: [
// // Container(
// // height: 200,
// // width: 200,
// // decoration: BoxDecoration(
// // borderRadius:
// // BorderRadius.circular(25),
// // image: DecorationImage(
// // image: CachedNetworkImageProvider(
// // '$apiUrl/${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
// // ),
// // ),
// // Container(
// // decoration: BoxDecoration(
// // borderRadius:
// // BorderRadius.circular(25),
// // gradient: LinearGradient(
// // begin: Alignment.topCenter,
// // end: Alignment.bottomCenter,
// // colors: [
// // kPrimaryColor
// //     .withOpacity(0.4),
// // kPrimaryColor
// //     .withOpacity(0.1),
// // kPrimaryColor.withOpacity(0.4)
// // ],
// // ),
// // ),
// // )
// // ],
// // ),
// // ),
// // ),
// // SizedBox(
// // height: getProportionateScreenHeight(25),
// // ),
// // Row(
// // crossAxisAlignment:
// // CrossAxisAlignment.baseline,
// // textBaseline: TextBaseline.alphabetic,
// // mainAxisAlignment: MainAxisAlignment.center,
// // children: [
// // Text(
// // radioProvider
// //     .stations[
// // radioProvider.currentIndex]
// //     .mhz,
// // style: const TextStyle(
// // color: Colors.white70,
// // fontSize: 35,
// // fontWeight: FontWeight.w900),
// // ),
// // const Text(
// // 'mhz',
// // style: TextStyle(
// // color: Colors.white70,
// // fontSize: 16,
// // fontStyle: FontStyle.italic),
// // ),
// // ],
// // ),
// // SizedBox(
// // height: getProportionateScreenHeight(50),
// // ),
// // Row(
// // // crossAxisAlignment: CrossAxisAlignment.end,
// // mainAxisAlignment: MainAxisAlignment.center,
// // children: [
// // _buildPreviousButton(radioProvider,
// // musicProvider, podcastProvider),
// // SizedBox(
// // width: getProportionateScreenWidth(50),
// // ),
// // _buildPlayButton(
// // radioProvider,
// // podcastProvider,
// // musicProvider,
// // playing),
// // SizedBox(
// // width: getProportionateScreenWidth(50),
// // ),
// // _buildNextButton(radioProvider,
// // musicProvider, podcastProvider)
// // ],
// // )
// // ],
// // ),
// // ],
// // ),
// // ),
// // );
// // });
// // }
// // return ListView(
// // children: [
// // Padding(
// // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
// // child: const Center(
// // child: Text(
// // 'No Data',
// // style: TextStyle(color: kGrey),
// // ),
// // ),
// // ),
// // ],
// // );
// // }
// // return ListView(
// // children: [
// // Padding(
// // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height  * 0.3),
// // child:  Center(
// // child: KinProgressIndicator(),
// // ),
// // ),
// // ],
// // );