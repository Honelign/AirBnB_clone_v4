import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/now_playing_music_indicator.dart';
import 'package:kin_music_player_app/components/now_playing_podcast_indicator.dart';
import 'package:kin_music_player_app/components/now_playing_radio_indicator.dart';

import 'package:kin_music_player_app/screens/library/library.dart';
import 'package:kin_music_player_app/screens/podcast/podcast.dart';
import 'package:kin_music_player_app/screens/settings/settings.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/home/home_screen.dart';
import '../constants.dart';

import '../screens/radio.dart';

import 'custom_animated_bottom_bar.dart';
import 'package:provider/provider.dart';

class CustomBottomAppBar extends StatefulWidget {
  static String routeName = "/bottomAppBar";

  const CustomBottomAppBar({Key? key}) : super(key: key);

  @override
  _CustomBottomAppBarState createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _currentIndex = 0;

  final _inactiveColor = kGrey;
  List<Widget> pages = [
    const HomeScreen(),
    const MyLibrary(),
    const Podcast(),
    const RadioScreen(),
    const Settings(),
    //makePayment(),
  ];

  Future<bool> checkIfEmailIsVerified() async {
    var user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) {
        return false;
      } else {
        return FirebaseAuth.instance.currentUser!.emailVerified;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<LoginProvider>(context, listen: false).getUserPrivilege(),
      builder: (context, snapshot) {
        // if verified
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: () async {
              bool willLeave = false;
              await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        backgroundColor: kPopupMenuBackgroundColor,
                        title: Text(
                          'Do you want to exit from Kin?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Provider.of<MusicPlayer>(context, listen: false)
                                    .player
                                    .stop();
                                Provider.of<MusicPlayer>(context, listen: false)
                                    .player
                                    .updateCurrentAudioNotification(
                                      showNotifications: false,
                                    );
                                willLeave = true;
                                Navigator.of(context).pop();
                                exit(0);
                              },
                              child: const Text(
                                'Yes',
                                style: TextStyle(color: kSecondaryColor),
                              )),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'No',
                              style: TextStyle(color: kSecondaryColor),
                            ),
                          )
                        ],
                      ));
              return willLeave;
            },
            child: Scaffold(
              body: getBody(),
              bottomNavigationBar: _buildBottomBar(),
            ),
          );
        }
        // email not verified
        else {
          return const KinProgressIndicator();
        }
      },
    );
  }

  Widget _buildBottomBar() {
    final musicProvider = Provider.of<MusicPlayer>(context);
    final podcastProvider = Provider.of<PodcastPlayer>(context);
    final radioProvider = Provider.of<RadioProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            PlayerBuilder.isPlaying(
              player: musicProvider.player,
              builder: (context, isPlaying) {
                return musicProvider.currentMusic == null
                    ? Container()
                    : musicProvider.isMusicInProgress(
                                musicProvider.currentMusic!) ||
                            musicProvider.isMusicLoaded
                        ? Visibility(
                            visible: musicProvider.miniPlayerVisibility,
                            child: NowPlayingMusicIndicator(
                              trackPrice: musicProvider.currentMusic!.priceETB
                                  .toString(),
                              isPurchased:
                                  musicProvider.currentMusic!.isPurchasedByUser,
                            ),
                          )
                        : Container();
              },
            ),
            PlayerBuilder.isPlaying(
              player: podcastProvider.player,
              builder: (context, isPlaying) {
                return podcastProvider.currentEpisode == null
                    ? Container()
                    : podcastProvider.isEpisodeInProgress(
                                podcastProvider.currentEpisode!) ||
                            podcastProvider.isEpisodeLoaded
                        ? Visibility(
                            visible: podcastProvider.miniPlayerVisibility,
                            child: const NowPlayingPodcastIndicator(),
                          )
                        : Container();
              },
            ),
            Visibility(
              child: const NowPlayingRadioIndicator(),
              visible: radioProvider.miniPlayerVisibility,
            )
          ],
        ),
        CustomAnimatedBottomBar(
          containerHeight: 60,
          backgroundColor: kPrimaryColor,
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          //  curve: Curves.easeIn,
          onItemSelected: (index) {
            if (index == 1) {
              setState(() {
                pages.removeAt(1);
                pages.insert(
                  1,
                  const MyLibrary(),
                ); //changed from playlist to library
              });
            }
            if (index == 2) {
              setState(() {
                pages.removeAt(2);
                pages.insert(
                  2,
                  const Podcast(),
                );
              });
            }
            if (index == 3) {
              setState(() {
                pages.removeAt(3);
                pages.insert(
                  3,
                  const RadioScreen(),
                );
              });
            }
            if (index == 4) {
              setState(() {
                pages.removeAt(4);
                pages.insert(
                  4,
                  const Settings(),
                );
              });
            }

            setState(() => _currentIndex = index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: FaIcon(FontAwesomeIcons.house),
              title: const Text('Home'),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.library_music),
              title: const Text(
                'My Library',
              ),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: FaIcon(FontAwesomeIcons.microphoneLines),
              title: const Text('Podcast'),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: FaIcon(FontAwesomeIcons.radio),
              title: const Text('Radio'),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Account'),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ),
            /*  BottomNavyBarItem(
              icon: const Icon(Icons.person),
              title: const Text('Payment'),
              activeColor: kSecondaryColor,
              inactiveColor: _inactiveColor,
              textAlign: TextAlign.center,
            ), */
          ],
        ),
      ],
    );
  }

  Widget getBody() {
    return IndexedStack(
      children: pages,
      index: _currentIndex,
    );
  }
}
