import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/favorite.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({
    Key? key,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.id,
    required this.musicIndex,
    required this.favoriteMusics,
    required this.music,
  }) : super(key: key);

  final double height, aspectRatio;
  final Music music;
  final String id;
  final int musicIndex;
  final List<Favorite> favoriteMusics;

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
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    List<Music> favoriteMusicsList = [];

    var musicProvider = Provider.of<MusicProvider>(context);
    for (int i = 0; i < favoriteMusics.length; i++) {
      favoriteMusicsList.add(favoriteMusics[i].music);
    }
    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Container(
          height: getProportionateScreenHeight(height),
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          p.albumMusicss = favoriteMusicsList;
                          p.setBuffering(musicIndex);
                          if (checkConnection(status)) {
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

                              p.setPlayer(
                                  p.player, podcastProvider, radioProvider);
                              radioProvider.setMiniPlayerVisibility(
                                  false); // TODO: Replace
                              p.handlePlayButton(
                                  music: music,
                                  index: musicIndex,
                                  album: Album(
                                    id: -2,
                                    title: 'Single Music $musicIndex',
                                    artist: 'kin',
                                    description: '',
                                    cover: 'assets/images/kin.png',
                                    artist_id: 1,

                                    // musics: favoriteMusicsList
                                    count: favoriteMusicsList.length,
                                    isPurchasedByUser: false, price: 60,
                                  ),
                                  musics: favoriteMusicsList);

                              p.setMusicStopped(false);
                              podcastProvider.setEpisodeStopped(true);
                              p.listenMusicStreaming();
                              podcastProvider.listenPodcastStreaming();

                              // add to recently played
                              musicProvider.addToRecentlyPlayed(music: music);

                              // add to popluar
                              musicProvider.countPopular(music: music);
                            }
                          } else {
                            kShowToast();
                          }
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1.02,
                                  child: Container(
                                      color: kSecondaryColor.withOpacity(0.1),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "$kinAssetBaseUrl/${music.cover}",
                                        fit: BoxFit.cover,
                                      )),
                                )),
                            SizedBox(
                              width: getProportionateScreenWidth(10),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    music.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          getProportionateScreenHeight(18),
                                    ),
                                  ),
                                  Text(
                                    music.artist,
                                    style: TextStyle(color: kGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        p.currentMusic == null
                            ? Container()
                            : p.currentMusic!.title ==
                                    favoriteMusics[musicIndex].music.title
                                ? TrackMusicPlayButton(
                                    music: music,
                                    index: musicIndex,
                                    // TODO:Replace
                                    album: Album(
                                        id: -2,
                                        title: 'Favorite',
                                        artist: 'kin',
                                        description: '',
                                        cover: 'assets/images/kin.png',
                                        //  musics: favoriteMusicsList
                                        count: favoriteMusicsList.length,
                                        artist_id: 1,
                                        isPurchasedByUser: false,
                                        price: 60),
                                  )
                                : Container(),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      'Are Your Sure',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'No',
                                          style: TextStyle(
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final provider = Provider.of<
                                                  FavoriteMusicProvider>(
                                              context,
                                              listen: false);
                                          provider.unFavMusic(id);
                                          Navigator.of(context).pop();
                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                          );
                                          provider.getFavMusic();
                                        },
                                        child: const Text(
                                          'Yes',
                                          style: TextStyle(
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: Center(
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white.withOpacity(0.65),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
