import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/components/animation_rotate.dart';
import 'package:kin_music_player_app/components/playlist_selector_dialog.dart';
import 'package:kin_music_player_app/components/position_seek_widget.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert' show utf8;

import '../../constants.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';

import '../../services/provider/playlist_provider.dart';

class NowPlayingMusic extends StatefulWidget {
  static const String routeName = '/nowPlaying';
  final Music? musicForId;

  NowPlayingMusic(this.musicForId);

  @override
  State<NowPlayingMusic> createState() => _NowPlayingMusicState();
}

class _NowPlayingMusicState extends State<NowPlayingMusic> {
  final double MODAL_HEADER_HEIGHT = 180;
  late int musicId;
  int selectedPlaylistId = 1;

  @override
  void initState() {
    musicId = widget.musicForId!.id;

    Provider.of<FavoriteMusicProvider>(context, listen: false)
        .isMusicFav(musicId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlayListProvider>(context, listen: false);

    int index = 0;
    Music? music;
    musicId = widget.musicForId!.id;
    var playerProvider = Provider.of<MusicPlayer>(context);
    playerProvider.audioSessionListener();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          child: SingleChildScrollView(
            child: PlayerBuilder.realtimePlayingInfos(
              player: playerProvider.player,
              builder: (context, info) {
                music = playerProvider.currentMusic;
                return Container(
                  height: MediaQuery.of(context).size.height - 45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        '$kinAssetBaseUrl/${music!.cover}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(
                      color: kPrimaryColor.withOpacity(0.5),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Icon
                                InkWell(
                                  child: const SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                const Text(
                                  "Now Playing",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(60),
                          ),

                          // album image
                          _buildAlbumCover(
                            albumCoverUrl: "$kinAssetBaseUrl/${music!.cover}",
                          ),
                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(60),
                          ),
                          // song title
                          _buildSongTitle(music),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(30),
                          ),

                          // action center
                          _buildActionCenter(),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(40),
                          ),

                          //  progress bar
                          _buildProgressBar(info, music!, playerProvider),

                          // spacer
                          SizedBox(
                            height: getProportionateScreenHeight(20),
                          ),

                          // control center
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRepeatButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildPreviousButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildPlayPauseButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildNextButton(playerProvider),
                              SizedBox(
                                width: getProportionateScreenWidth(5),
                              ),
                              _buildShuffleButton(playerProvider)
                            ],
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(25),
                            height: 35,
                          ),
                          music!.lyrics!.isNotEmpty
                              ? _buildScrollableLyrics(
                                  context,
                                  utf8.decode(
                                    music!.lyrics!
                                        .replaceAll('<p>', '')
                                        .replaceAll('</p>', '')
                                        .replaceAll('\\r', '')
                                        .replaceAll('\\n', '\n')
                                        .replaceAll('\\', '')
                                        .runes
                                        .toList(),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumCover({required String albumCoverUrl}) {
    return CachedNetworkImage(
      imageUrl: albumCoverUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: MediaQuery.of(context).size.width * 0.65,
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
      RealtimePlayingInfos info, Music music, MusicPlayer playerProvider) {
    return PositionSeekWidget(
      currentPosition: info.currentPosition,
      duration: //just a dummy time if stream
          info.duration,
      seekTo: (to) {
        playerProvider.player.seek(to);
      },
    );
  }

  Widget _buildActionCenter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // favorite button
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.favorite,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),

          // Tip Button
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.money_sharp,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),

          // buy
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.monetization_on,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),

          // add to playlist
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) {
                  return PlaylistSelectorDialog(
                    trackId: musicId.toString(),
                  );
                },
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),

          // Download
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.download,
              color: Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTitle(Music? music) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                music!.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Text(
            music.artist.isNotEmpty ? music.artist : "kin artist",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: kGrey,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRepeatButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: Icon(
        !playerProvider.loopPlaylist && playerProvider.loopMode
            ? Icons.repeat_one_rounded
            : Icons.repeat_rounded,
        size: 20,
      ),
      color: playerProvider.shuffled ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleLoop(),
    );
  }

  Widget _buildPreviousButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 28,
      ),
      color: playerProvider.isFirstMusic() ? kGrey : Colors.white,
      onPressed: () {
        playerProvider.prev();
      },
    );
  }

  Widget _buildPlayPauseButton(MusicPlayer playerProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
      player: playerProvider.player,
      builder: (context, isPlaying) {
        return InkWell(
          onTap: () {
            if (isPlaying || playerProvider.player.isBuffering.value) {
              playerProvider.player.pause();
            } else {
              if (checkConnection(status)) {
                playerProvider.player.play();
              } else {
                kShowToast();
              }
            }
          },
          child: !playerProvider.isMusicLoaded
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
              : isPlaying
                  ? const Icon(
                      Icons.pause_rounded,
                      size: 36,
                      color: Colors.white,
                    )
                  : const Icon(
                      Icons.play_arrow_rounded,
                      size: 36,
                      color: Colors.white,
                    ),
        );
      },
    );
  }

  Widget _buildNextButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.skip_next_rounded,
        size: 28,
      ),
      color: playerProvider.isLastMusic(playerProvider.currentIndex! + 1)
          ? kGrey
          : Colors.white,
      onPressed: () {
        if (playerProvider.isLastMusic(playerProvider.currentIndex! + 1)) {
          return;
        }
        playerProvider.next();
      },
    );
  }

  Widget _buildShuffleButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(
        Icons.shuffle_rounded,
        size: 20,
      ),
      color: playerProvider.shuffled ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleShuffle(),
    );
  }

  Widget _buildScrollableLyrics(BuildContext context, lyrics) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onVerticalDragStart: (DragStartDetails dragStartDetails) {
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: kGrey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(50),
                      left: getProportionateScreenWidth(100)),
                  child: SizedBox(
                      width: double.infinity,
                      child:
                          // child: Html(
                          //   data: lyrics,

                          //   style: {
                          //     'p': Style(
                          //         color: Colors.white,
                          //         fontFamily: 'Nokia',
                          //         lineHeight: LineHeight.number(2))
                          //   },
                          // )
                          Text(
                        lyrics,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontFamily: 'Nokia',
                          fontSize: 18,
                        ),
                      )),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: kGrey.withOpacity(0.15),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(
              Icons.expand_less,
              color: kSecondaryColor,
            ),
            Center(
              child: Text(
                'Lyrics',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
