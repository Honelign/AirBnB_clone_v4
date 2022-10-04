import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
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

import 'album_card.dart';

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
  bool _showLoader = false;

  @override
  void initState() {
    _showLoader = true;
    super.initState();
  }

  @override
  void dispose() {
    _showLoader = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _showLoader = false;
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
                          const SizedBox(
                            height: 16,
                          ),

                          // Album Art
                          _buildAlbumArt(
                            "$kinAssetBaseUrl/${widget.album.cover}",
                          ),

                          // spacer
                          const SizedBox(
                            height: 12,
                          ),

                          // album title
                          Text(
                            widget.album.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),

                          // spacer
                          const SizedBox(
                            height: 4,
                          ),

                          // artist title
                          Text(
                            widget.album.artist,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          // spacer
                          const SizedBox(
                            height: 20,
                          ),

                          // play all button
                          _buildPlayAllButton(context),
                        ],
                      ),
                    ),

                    // spacer
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),

                    // Scrollable Album View
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: _buildAlbumMusics(widget.albumMusicsFromCard,
                              context, widget.album.id),
                        ),
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

  Widget _buildAlbumMusics(musics, context, id) {
    return FutureBuilder<List<Music>>(
      future: Provider.of<MusicProvider>(context, listen: false)
          .albumMusicsGetter(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        List<Music> albumMusics = snapshot.data ?? [];
        _showLoader = false;
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

  Widget _buildPlayAllButton(ctx) {
    var playerProvider = Provider.of<MusicPlayer>(
      ctx,
      listen: false,
    );
    var podcastProvider = Provider.of<PodcastPlayer>(
      ctx,
      listen: false,
    );
    var musicProvider = Provider.of<MusicPlayer>(
      ctx,
      listen: false,
    );
    var radioProvider = Provider.of<RadioProvider>(
      ctx,
      listen: false,
    );
    MusicProvider musicProv =
        Provider.of<MusicProvider>(context, listen: false);
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    //
    return FutureBuilder<List<Music>>(
        future: musicProv.albumMusicsGetter(widget.album.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const KinProgressIndicator();
          } else {
            return PlayerBuilder.isPlaying(
              player: playerProvider.player,
              builder: ((context, isPlaying) {
                return InkWell(
                  onTap: () {
                    if (playerProvider.currentMusic == null) {
                      if (checkConnection(status)) {
                        radioProvider.player.stop();
                        podcastProvider.player.stop();

                        podcastProvider.setEpisodeStopped(true);
                        podcastProvider.listenPodcastStreaming();

                        musicProvider.setPlayer(musicProvider.player,
                            podcastProvider, radioProvider);
                        playerProvider.handlePlayButton(
                          musics: snapshot.data!,
                          album: widget.album,
                          music: snapshot.data![0],
                          index: 0,
                        );
                        podcastProvider.setEpisodeStopped(true);
                        podcastProvider.listenPodcastStreaming();
                      } else {
                        kShowToast();
                      }
                    } else if (playerProvider.player.getCurrentAudioTitle ==
                            playerProvider.currentMusic!.title &&
                        widget.album.id == playerProvider.currentAlbum.id) {
                      if (isPlaying ||
                          playerProvider.player.isBuffering.value) {
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

                        playerProvider.setPlayer(playerProvider.player,
                            podcastProvider, radioProvider);
                        playerProvider.handlePlayButton(
                          musics: snapshot.data!,
                          album: widget.album,
                          music: snapshot.data![0],
                          index: 0,
                        );
                        playerProvider.setMusicStopped(false);
                        podcastProvider.setEpisodeStopped(true);
                        playerProvider.listenMusicStreaming();
                        podcastProvider.listenPodcastStreaming();
                      } else {
                        kShowToast();
                      }
                    }
                  },
                  child: isPlaying &&
                          widget.album.id == playerProvider.currentAlbum.id
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: kPopupMenuBackgroundColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: kPrimaryColor,
                                offset: Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ), //BoxShadow
                              //BoxShadow
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(
                                child: Icon(
                                  Icons.pause,
                                  color: kSecondaryColor,
                                  size: 24,
                                ),
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Playing",
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 9,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: kPopupMenuBackgroundColor,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(
                                color: kPrimaryColor,
                                offset: Offset(
                                  1.0,
                                  1.0,
                                ),
                                blurRadius: 2.0,
                                spreadRadius: 1.0,
                              ), //BoxShadow
                              //BoxShadow
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.play_arrow,
                                color: kSecondaryColor,
                                size: 24,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Play All",
                                style: TextStyle(
                                  color: kSecondaryColor,
                                  fontSize: 22,
                                ),
                              )
                            ],
                          ),
                        ),
                );
              }),
            );
          }
        });
  }
}
