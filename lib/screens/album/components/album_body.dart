import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import 'playlist_card.dart';

class AlbumBody extends StatefulWidget {
  static String routeName = '/decoration';

  final Album album;
  final List<Music> albumMusicsFromCard;

  const AlbumBody({
    Key? key,
    required this.album,
    required this.albumMusicsFromCard,
  }) : super(key: key);

  @override
  State<AlbumBody> createState() => _AlbumBodyState();
}

class _AlbumBodyState extends State<AlbumBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  '$kinAssetBaseUrl/${widget.album.cover}',
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
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // _buildTitleSection(widget.album),

                          // back button
                          Container(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildBackButton(context),
                              ],
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                          ),

                          // spacer
                          SizedBox(
                            height: 16,
                          ),

                          // Album Art
                          _buildAlbumArt(
                            "$kinAssetBaseUrl/${widget.album.cover}",
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          Text(
                            widget.album.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.album.artist,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          SizedBox(
                            height: 4,
                          ),
                          // Text(
                          //   widget.album.count == 0
                          //       ? "No items"
                          //       : widget.album.count == 1
                          //           ? "1 item"
                          //           : widget.album.count.toString() + " items",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 10,
                          //   ),
                          // ),

                          // _buildAlbumInfo(),
                          // _buildPlayAllIcon(
                          //   context,
                          //   widget.albumMusicsFromCard,
                          // )

                          SizedBox(
                            height: 16,
                          ),

                          // button
                          Container(
                            child: InkWell(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 9,
                                    horizontal: 30,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPopupMenuBackgroundColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.shuffle_rounded,
                                        color: kSecondaryColor,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        "Shuffle All",
                                        style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Expanded(
                        child: _buildAlbumMusics(widget.albumMusicsFromCard,
                            context, widget.album.id),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt(image) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
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

  Widget _buildBackButton(BuildContext context) {
    return BackButton(
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAlbumInfo() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: getProportionateScreenHeight(280) -
            getProportionateScreenHeight(245),
        width: double.infinity,
        color: kPrimaryColor.withOpacity(0.5),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
          vertical: getProportionateScreenHeight(5),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "${widget.album.count} songs",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayAllIcon(context, musics) {
    var playerProvider = Provider.of<MusicPlayer>(
      context,
    );
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: PlayerBuilder.isPlaying(
          player: playerProvider.player,
          builder: (context, isPlaying) {
            return InkWell(
              onTap: () {
                if (playerProvider.currentMusic == null) {
                  if (checkConnection(status)) {
                    radioProvider.player.stop();
                    podcastProvider.player.stop();

                    podcastProvider.setEpisodeStopped(true);
                    podcastProvider.listenPodcastStreaming();

                    musicProvider.setPlayer(
                        musicProvider.player, podcastProvider, radioProvider);
                    playerProvider.handlePlayButton(
                        musics: widget.albumMusicsFromCard,
                        album: widget.album,
                        music: musics[0],
                        index: 0);
                    podcastProvider.setEpisodeStopped(true);
                    podcastProvider.listenPodcastStreaming();
                  } else {
                    kShowToast();
                  }
                } else if (playerProvider.player.getCurrentAudioTitle ==
                        playerProvider.currentMusic!.title &&
                    widget.album.id == playerProvider.currentAlbum.id) {
                  if (isPlaying || playerProvider.player.isBuffering.value) {
                    playerProvider.player.pause();
                  } else {
                    if (checkConnection(status)) {
                      playerProvider.player.play();
                    } else {
                      kShowToast();
                    }
                  }
                } else {
                  if (checkConnection(status)) {
                    radioProvider.player.stop();
                    podcastProvider.player.stop();
                    playerProvider.player.stop();

                    playerProvider.setMusicStopped(true);
                    podcastProvider.setEpisodeStopped(true);
                    playerProvider.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();

                    playerProvider.setPlayer(
                        playerProvider.player, podcastProvider, radioProvider);
                    playerProvider.handlePlayButton(
                        musics: widget.albumMusicsFromCard,
                        album: widget.album,
                        music: musics[0],
                        index: 0);
                    playerProvider.setMusicStopped(false);
                    podcastProvider.setEpisodeStopped(true);
                    playerProvider.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();
                  } else {
                    kShowToast();
                  }
                }
              },
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 15,
                  child: !playerProvider.isMusicLoaded
                      ? SpinKitFadingCircle(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? kSecondaryColor
                                    : Colors.white,
                              ),
                            );
                          },
                          size: 30,
                        )
                      : SvgPicture.asset(
                          isPlaying &&
                                  widget.album.id ==
                                      playerProvider.currentAlbum.id
                              ? 'assets/icons/pause.svg'
                              : 'assets/icons/play.svg',
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlbumMusics(musics, context, id) {
    return FutureBuilder<List<Music>>(
      future: Provider.of<MusicProvider>(context, listen: false)
          .albumMusicsGetter(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const KinProgressIndicator();
        }
        List<Music> albumMusics = snapshot.data ?? [];
        return ListView.builder(
          itemCount: albumMusics.length,
          itemBuilder: (context, index) {
            return AlbumCard(
              albumMusics: albumMusics,
              music: albumMusics[index],
              musicIndex: index,
              album: widget.album,
            );
          },
        );
      },
    );
  }
}
