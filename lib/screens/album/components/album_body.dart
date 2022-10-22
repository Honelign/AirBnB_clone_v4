import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/components/download/multiple_download_progress_display_component.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
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
    helper.makeStatusBarTransparent();

    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        top: false,
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
                padding: const EdgeInsets.only(top: 32),
                color: kPrimaryColor.withOpacity(0.5),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
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
                            checkConnection(status) == false
                                ? Container()
                                : _buildPlayAllButton(context),
                          ],
                        ),
                      ),

                      // spacer
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),

                      // Scrollable Album View
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
                          child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.5 - 20,
                            child: checkConnection(status) == false
                                ? RefreshIndicator(
                                    onRefresh: () async {
                                      setState(() {});
                                    },
                                    backgroundColor:
                                        refreshIndicatorBackgroundColor,
                                    color: refreshIndicatorForegroundColor,
                                    child: const NoConnectionDisplay(),
                                  )
                                : _buildAlbumMusics(widget.albumMusicsFromCard,
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
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        // album has song
        if (snapshot.data!.isNotEmpty) {
          List<Music> albumMusics = snapshot.data ?? [];
          _showLoader = false;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            child: ListView.builder(
              itemCount: albumMusics.length,
              itemBuilder: (context, index) {
                return AlbumCard(
                  albumMusics: albumMusics,
                  music: albumMusics[index],
                  musicIndex: index,
                  album: widget.album,
                );
              },
            ),
          );
        }
        // no tracks
        else {
          return Column(
            children: [
              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(60),
              ),
              // ignore: avoid_unnecessary_containers
              Container(
                child: Text(
                  "No Tracks",
                  style: noDataDisplayStyle,
                ),
              ),
            ],
          );
        }
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
          return Container(
            margin: const EdgeInsets.only(top: 32),
            child: const KinProgressIndicator(),
          );
        } else {
          // return PlayerBuilder.isPlaying(
          //   player: playerProvider.player,
          //   builder: ((context, isPlaying) {
          //     return InkWell(
          //       onTap: () {
          //         if (playerProvider.currentMusic == null) {
          //           if (checkConnection(status)) {
          //             radioProvider.player.stop();
          //             podcastProvider.player.stop();

          //             podcastProvider.setEpisodeStopped(true);
          //             podcastProvider.listenPodcastStreaming();

          //             musicProvider.setPlayer(musicProvider.player,
          //                 podcastProvider, radioProvider);
          //             playerProvider.handlePlayButton(
          //               musics: snapshot.data!,
          //               album: widget.album,
          //               music: snapshot.data![0],
          //               index: 0,
          //             );
          //             podcastProvider.setEpisodeStopped(true);
          //             podcastProvider.listenPodcastStreaming();
          //           } else {
          //             kShowToast();
          //           }
          //         } else if (playerProvider.player.getCurrentAudioTitle ==
          //                 playerProvider.currentMusic!.title &&
          //             widget.album.id == playerProvider.currentAlbum.id) {
          //           if (isPlaying ||
          //               playerProvider.player.isBuffering.value) {
          //             playerProvider.player.pause();
          //           } else {
          //             if (checkConnection(status)) {
          //               playerProvider.player.play();
          //             } else {
          //               kShowToast();
          //             }
          //           }
          //         } else {
          //           if (checkConnection(status)) {
          //             radioProvider.player.stop();
          //             podcastProvider.player.stop();
          //             playerProvider.player.stop();

          //             playerProvider.setMusicStopped(true);
          //             podcastProvider.setEpisodeStopped(true);
          //             playerProvider.listenMusicStreaming();
          //             podcastProvider.listenPodcastStreaming();

          //             playerProvider.setPlayer(playerProvider.player,
          //                 podcastProvider, radioProvider);
          //             playerProvider.handlePlayButton(
          //               musics: snapshot.data!,
          //               album: widget.album,
          //               music: snapshot.data![0],
          //               index: 0,
          //             );
          //             playerProvider.setMusicStopped(false);
          //             podcastProvider.setEpisodeStopped(true);
          //             playerProvider.listenMusicStreaming();
          //             podcastProvider.listenPodcastStreaming();
          //           } else {
          //             kShowToast();
          //           }
          //         }
          //       },
          //       child: isPlaying &&
          //               widget.album.id == playerProvider.currentAlbum.id
          //           ? Container(
          //               padding: const EdgeInsets.symmetric(
          //                 vertical: 9,
          //                 horizontal: 30,
          //               ),
          //               decoration: BoxDecoration(
          //                 color: kPopupMenuBackgroundColor,
          //                 borderRadius: BorderRadius.circular(25),
          //                 boxShadow: const [
          //                   BoxShadow(
          //                     color: kPrimaryColor,
          //                     offset: Offset(
          //                       1.0,
          //                       1.0,
          //                     ),
          //                     blurRadius: 2.0,
          //                     spreadRadius: 1.0,
          //                   ), //BoxShadow
          //                   //BoxShadow
          //                 ],
          //               ),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Center(
          //                     child: Icon(
          //                       Icons.pause,
          //                       color: kSecondaryColor,
          //                       size: 24,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     width: 6,
          //                   ),
          //                   Text(
          //                     "Playing",
          //                     style: TextStyle(
          //                       color: kSecondaryColor,
          //                       fontSize: 22,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             )
          //           : Container(
          //               padding: const EdgeInsets.symmetric(
          //                 vertical: 9,
          //                 horizontal: 30,
          //               ),
          //               decoration: BoxDecoration(
          //                 color: kPopupMenuBackgroundColor,
          //                 borderRadius: BorderRadius.circular(25),
          //                 boxShadow: const [
          //                   BoxShadow(
          //                     color: kPrimaryColor,
          //                     offset: Offset(
          //                       1.0,
          //                       1.0,
          //                     ),
          //                     blurRadius: 2.0,
          //                     spreadRadius: 1.0,
          //                   ), //BoxShadow
          //                   //BoxShadow
          //                 ],
          //               ),
          //               child: Row(
          //                 mainAxisSize: MainAxisSize.min,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: const [
          //                   Icon(
          //                     Icons.play_arrow,
          //                     color: kSecondaryColor,
          //                     size: 24,
          //                   ),
          //                   SizedBox(
          //                     width: 6,
          //                   ),
          //                   Text(
          //                     "Play All",
          //                     style: TextStyle(
          //                       color: kSecondaryColor,
          //                       fontSize: 22,
          //                     ),
          //                   )
          //                 ],
          //               ),
          //             ),
          //     );
          //   }),
          // );

          return PlayerBuilder.isPlaying(
              player: playerProvider.player,
              builder: (context, isPlaying) {
                return Container(
                  width: 100,
                  height: 40,
                  // color: Colors.amber,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
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
                          } else if (playerProvider
                                      .player.getCurrentAudioTitle ==
                                  playerProvider.currentMusic!.title &&
                              widget.album.id ==
                                  playerProvider.currentAlbum.id) {
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
                        icon: isPlaying &&
                                widget.album.id ==
                                    playerProvider.currentAlbum.id
                            ? const Icon(
                                Icons.pause,
                                color: kGrey,
                                size: 30,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                color: kGrey,
                                size: 30,
                              ),
                      ),
                      IconButton(
                        onPressed: () async {
                          // if connection
                          if (checkConnection(status) == true) {
                            // request permission
                            Map<Permission, PermissionStatus>
                                storagePermissionStatus = await [
                              Permission.storage,
                            ].request();

                            // if permission given
                            if (storagePermissionStatus[Permission.storage]!
                                .isGranted) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MultipleDownloadProgressDisplayComponent(
                                    musics: snapshot.data!,
                                  );
                                },
                              );
                            }
                            // permission denied
                            else {
                              kShowToast(message: "Storage Permission Denied");
                            }
                          }
                          // no connection
                          else {
                            kShowToast(message: "No Connection");
                          }
                        },
                        icon: const Icon(
                          Icons.download,
                          color: kGrey,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}
