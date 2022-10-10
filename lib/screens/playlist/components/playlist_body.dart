import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_add_tracks.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_track_card.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../components/download/multiple_download_progress_display_component.dart';

class PlaylistBody extends StatefulWidget {
  final int playlistId;
  final String playlistName;
  const PlaylistBody(
      {Key? key, required this.playlistId, required this.playlistName})
      : super(key: key);

  @override
  State<PlaylistBody> createState() => _PlaylistBodyState();
}

class _PlaylistBodyState extends State<PlaylistBody> {
  late PlayListProvider playListProvider;
  List<Music> allTracksInPlaylist = [];

  static const _pageSize = 1;

  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    playListProvider = Provider.of<PlayListProvider>(context, listen: false);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreTracksUnderPlaylist(pageKey: pageKey);
    });
    super.initState();
  }

  Future _fetchMoreTracksUnderPlaylist({required int pageKey}) async {
    try {
      final newItems = await playListProvider.getTracksUnderPlaylistById(
        playlistId: widget.playlistId,
        pageKey: pageKey,
      );

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;

        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void refresh() {
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(widget.playlistName),
        actions: [
          // Add tracks button
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
            child: IconButton(
              onPressed: () {
                // go to detail page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTracksToPlaylist(
                      playlistName: widget.playlistName,
                      playlistId: widget.playlistId.toString(),
                      refresherFunction: refresh,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add,
                color: kGrey,
              ),
            ),
          ),

          // download all button
          FutureBuilder<List<Music>>(
            future: playListProvider.getTracksUnderPlaylistById(
                playlistId: widget.playlistId),
            builder: ((context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              }

              // loaded
              else {
                return Padding(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(8)),
                  child: IconButton(
                    onPressed: () async {
                      // print(snapshot.data);
                      // if connection
                      if (checkConnection(status) == true) {
                        print("Downloading All");
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
                    ),
                  ),
                );
              }
            }),
          )
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
            },
            backgroundColor: refreshIndicatorBackgroundColor,
            color: refreshIndicatorForegroundColor,
            child: PagedListView<int, Music>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Music>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 500),
                noItemsFoundIndicatorBuilder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                      "No Tracks in ${widget.playlistName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                noMoreItemsIndicatorBuilder: (_) => Container(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
                  child: Center(
                    child: Text(
                      "No More Items in ${widget.playlistName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                firstPageProgressIndicatorBuilder: (_) =>
                    const KinProgressIndicator(),
                newPageProgressIndicatorBuilder: (_) =>
                    const KinProgressIndicator(),
                itemBuilder: (context, item, index) {
                  allTracksInPlaylist = _pagingController.itemList ?? [];
                  return PlaylistListCard(
                    music: item,
                    musics: _pagingController.itemList ?? [],
                    musicIndex: index,
                    refresherFunction: refresh,
                  );
                },
              ),
            ),
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: _buildPlayAllButton(ctx: context),
    );
  }

  Widget _buildPlayAllButton({required BuildContext ctx}) {
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

    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: FutureBuilder<List<Music>>(
        future: playListProvider.getTracksUnderPlaylistById(
          playlistId: widget.playlistId,
        ),
        builder: (context, snapshot) {
          //
          if (snapshot.connectionState != ConnectionState.waiting &&
              !snapshot.hasError &&
              snapshot.hasData) {
            return PlayerBuilder.isPlaying(
              player: playerProvider.player,
              builder: ((context, isPlaying) {
                return FloatingActionButton(
                  backgroundColor: kSecondaryColor,
                  onPressed: () async {
                    playerProvider.albumMusicss = allTracksInPlaylist;

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
                          album: Album(
                            id: -1,
                            title: "Kin Music",
                            artist: "Kin",
                            description: "",
                            cover: "",
                            artist_id: -1,
                            price: 0,
                            isPurchasedByUser: false,
                          ),
                          music: snapshot.data![0],
                          index: 0,
                        );
                        podcastProvider.setEpisodeStopped(true);
                        podcastProvider.listenPodcastStreaming();
                      } else {
                        kShowToast();
                      }
                    } else if (playerProvider.player.getCurrentAudioTitle ==
                        playerProvider.currentMusic!.title) {
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
                          album: Album(
                            id: -1,
                            title: "Kin Music",
                            artist: "Kin",
                            description: "",
                            cover: "",
                            artist_id: -1,
                            price: 0,
                            isPurchasedByUser: false,
                          ),
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
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                );
              }),
            );
          }

          //
          else {
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const KinProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
