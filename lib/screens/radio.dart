import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({Key? key}) : super(key: key);

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  int index = 0;
  bool isLoading = false;
  bool isPlaying = false;
  var future;

  @override
  void initState() {
    future = context.read<RadioProvider>().getStations();
    super.initState();
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
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text('Radio',),
          backgroundColor: Colors.black,
        ),
        body: FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot snapshot) {
            if (!(snapshot.connectionState == ConnectionState.waiting)) {
              if (snapshot.hasData) {
                return PlayerBuilder.isPlaying(
                    player: radioProvider.player,
                    builder: (context, playing) {
                      return Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: CachedNetworkImageProvider(
                                  '${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
                          // color: Colors.red,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                          child: Stack(
                            children: [
                              RefreshIndicator(
                                onRefresh: () async{
                                  setState(() {
                                    
                                  });
                                },
                                child: Container(
                                  // ignore: prefer_const_constructors
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                  
                                  ),
                                ),
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                              
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(50),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Card(
                                      elevation: 25,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      '${radioProvider.stations[radioProvider.currentIndex].coverImage}')),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  kPrimaryColor
                                                      .withOpacity(0.4),
                                                  kPrimaryColor
                                                      .withOpacity(0.1),
                                                  kPrimaryColor.withOpacity(0.4)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(25),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        radioProvider
                                            .stations[
                                                radioProvider.currentIndex]
                                            .mhz
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 35,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      const Text(
                                        'mhz',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(50),
                                  ),
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildPreviousButton(radioProvider,
                                          musicProvider, podcastProvider),
                                      SizedBox(
                                        width: getProportionateScreenWidth(50),
                                      ),
                                      _buildPlayButton(
                                          radioProvider,
                                          podcastProvider,
                                          musicProvider,
                                          playing),
                                      SizedBox(
                                        width: getProportionateScreenWidth(50),
                                      ),
                                      _buildNextButton(radioProvider,
                                          musicProvider, podcastProvider)
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
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
            return Center(
              child: KinProgressIndicator(),
            );
          },
        ));
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
          width: 70,
          height: 70,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
           
            boxShadow: [BoxShadow(
                      color: Colors.black,
                      offset: const Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                    ), ],
              color: kSecondaryColor.withOpacity(0.8),
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
                    width: 30,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
