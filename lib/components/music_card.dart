import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/download/download_progress_display_component.dart';
import 'package:kin_music_player_app/components/music_detail_display.dart';
import 'package:kin_music_player_app/components/playlist_selector_dialog.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';

// ignore: must_be_immutable
class MusicCard extends StatefulWidget {
  final double width, aspectRatio;
  final Music music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;

  MusicCard({
    Key? key,
    this.width = 125,
    this.aspectRatio = 1.02,
    required this.music,
    required this.musics,
    this.musicIndex = -1,
    this.isForPlaylist,
  }) : super(key: key);

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

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
    OfflineMusicProvider offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(
      context,
    );

    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
          child: SizedBox(
            width: getProportionateScreenWidth(widget.width),
            child: InkWell(
              onTap: () async {
                // first play call
                // if (_musicPlayerController.isProcessingPlay == false) {

                p.albumMusicss = widget.musics;
                p.isPlayingLocal = false;
                p.setBuffering(widget.musicIndex);
                // if (checkConnection(status)) {
                // incrementMusicView(music.id);
                p.setBuffering(widget.musicIndex);

                if (p.isMusicInProgress(widget.music)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NowPlayingMusic(widget.music),
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

                  p.handlePlayButton(
                    music: widget.music,
                    index: widget.musicIndex,
                    album: Album(
                      id: -2,
                      title: 'Single Music ${widget.musicIndex}',
                      artist: 'kin',
                      description: '',
                      cover: 'assets/images/kin.png',
                      count: widget.musics.length,
                      artist_id: 1,
                      isPurchasedByUser: false,
                      price: 60,
                    ),
                    musics: widget.musics,
                  );
                  // _musicPlayerController.setIsProcessingPlayToFalse();

                  p.setMusicStopped(false);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();
                  podcastProvider.listenPodcastStreaming();

                  // add to recently played
                  musicProvider.addToRecentlyPlayed(music: widget.music);

                  // add to popular
                  musicProvider.countPopular(music: widget.music);
                }
                // } else {
                //   kShowToast(message: "No Connection");
                // }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 1.3,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '$kinAssetBaseUrl/${widget.music.cover}',
                              fit: BoxFit.cover,
                              width: getProportionateScreenWidth(widget.width),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: p.currentMusic == null
                                ? Container()
                                : p.currentMusic!.title ==
                                        widget.musics[widget.musicIndex].title
                                    ? TrackMusicPlayButton(
                                        music: widget.music,
                                        index: widget.musicIndex,
                                        album: Album(
                                          id: -2,
                                          title:
                                              'Single Music ${widget.musicIndex}',
                                          artist: 'kin',
                                          description: '',
                                          cover: 'assets/images/kin.png',
                                          count: widget.musics.length,
                                          artist_id: 1,
                                          isPurchasedByUser: false,
                                          price: 60,
                                        ),
                                      )
                                    : Container(),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: getProportionateScreenWidth(100),
                          child: Text(
                            widget.music.title,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                          initialValue: 0,
                          child: const Icon(
                            Icons.more_vert,
                            color: kGrey,
                          ),
                          color: Colors.white.withOpacity(0.95),
                          elevation: 10,
                          onSelected: (value) async {
                            // Add to playlist
                            if (value == 1) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return PlaylistSelectorDialog(
                                    trackId: widget.music.id.toString(),
                                  );
                                },
                              );
                            }
                            // music detail
                            else if (value == 2) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return MusicDetailDisplay(
                                    music: widget.music,
                                  );
                                },
                              );
                            }
                            // download
                            else if (value == 3) {
                              // check connectivity
                              // check if purchased by user
                              // check if already downloaded
                              if (checkConnection(status) == false) {
                                kShowToast(
                                    message: "No connection to download");
                              } else if (widget.music.isPurchasedByUser ==
                                  false) {
                                kShowToast(
                                    message:
                                        "Purchase music to access it offline");
                              } else {
                                bool isMusicDownloaded =
                                    await offlineMusicProvider
                                        .checkTrackInOfflineCache(
                                  musicId: widget.music.id.toString(),
                                );

                                if (isMusicDownloaded == true) {
                                  kShowToast(
                                      message:
                                          "Music already available offline");
                                } else {
                                  // request permission
                                  Map<Permission, PermissionStatus>
                                      storagePermissionStatus = await [
                                    Permission.storage,
                                    //add more permission to request here.
                                  ].request();

                                  if (storagePermissionStatus[
                                          Permission.storage]!
                                      .isGranted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return DownloadProgressDisplayComponent(
                                          music: widget.music,
                                        );
                                      },
                                    );
                                  } else {
                                    kShowToast(
                                        message: "Storage Permission Denied");
                                  }
                                }
                              }

                              //   if (widget.music.isPurchasedByUser == true) {
                              //     bool isMusicDownloaded =
                              //         await offlineMusicProvider
                              //             .checkTrackInOfflineCache(
                              //       musicId: widget.music.id.toString(),
                              //     );

                              //     if (isMusicDownloaded == true) {
                              //       kShowToast(
                              //           message:
                              //               "Music already available offline");
                              //     } else {
                              //       // request permission
                              //       Map<Permission, PermissionStatus> statuses =
                              //           await [
                              //         Permission.storage,
                              //         //add more permission to request here.
                              //       ].request();
                              //       if (statuses[Permission.storage]!.isGranted) {
                              //         showDialog(
                              //           context: context,
                              //           builder: (context) {
                              //             return DownloadProgressDisplayComponent(
                              //               music: widget.music,
                              //             );
                              //           },
                              //         );
                              //       } else {
                              //         kShowToast(
                              //             message: "Storage Permission Denied");
                              //       }
                              //     }
                              //   }
                              // } else {
                              //   kShowToast(message: "Purchase to download music");
                            }
                          },
                          itemBuilder: (context) {
                            return kMusicPopupMenuItem;
                          },
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.music.artist.isNotEmpty
                        ? widget.music.artist
                        : 'kin artist',
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis, color: kGrey),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
