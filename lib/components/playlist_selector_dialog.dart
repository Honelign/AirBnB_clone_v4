import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_info.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class PlaylistSelectorDialog extends StatefulWidget {
  final String trackId;

  const PlaylistSelectorDialog({Key? key, required this.trackId})
      : super(key: key);

  @override
  State<PlaylistSelectorDialog> createState() => _PlaylistSelectorDialogState();
}

class _PlaylistSelectorDialogState extends State<PlaylistSelectorDialog> {
  late PlayListProvider playListProvider;

  static const _pageSize = 1;
  final PagingController<int, PlaylistInfo> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    playListProvider = Provider.of<PlayListProvider>(context, listen: false);

    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchMorePlaylists(pageKey);
      },
    );

    super.initState();
  }

  Future _fetchMorePlaylists(int pageKey) async {
    try {
      final newItems = await playListProvider.getPlayList(pageKey: pageKey);
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
    setState(() {});
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: (BuildContext context, playListProvider, _) {
        return SimpleDialog(
          backgroundColor: const Color.fromARGB(255, 42, 41, 41),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          elevation: 10,
          children: playListProvider.isLoading == false
              ? [
                  // title
                  Text(
                    "Select a Playlist",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // spacer
                  const SizedBox(
                    height: 20,
                  ),

                  // list view
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: getProportionateScreenHeight(320),
                    child: RefreshIndicator(
                      onRefresh: () async {},
                      child: PagedListView<int, PlaylistInfo>(
                        pagingController: _pagingController,
                        builderDelegate:
                            PagedChildBuilderDelegate<PlaylistInfo>(
                          animateTransitions: true,
                          transitionDuration: const Duration(milliseconds: 500),
                          noItemsFoundIndicatorBuilder: (context) => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: Text(
                                "No Playlist",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          noMoreItemsIndicatorBuilder: (_) => Container(
                            padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
                            child: const Center(
                              child: Text(
                                "No More Playlists",
                                style: TextStyle(
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
                          itemBuilder: ((context, item, index) {
                            return InkWell(
                              onTap: () async {
                                refresh();
                                bool result =
                                    await playListProvider.addMusicToPlaylist(
                                  playlistId: item.id.toString(),
                                  trackId: widget.trackId,
                                );

                                refresh();

                                if (result) {
                                  kShowToast(message: "Added to playlist");
                                  Navigator.pop(context, true);
                                } else {
                                  kShowToast(message: "Already in playlist");
                                }
                              },
                              child: PlaylistTitleDisplay(
                                playlistInfo: item,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),

                  // spacer
                  const SizedBox(
                    height: 20,
                  ),

                  // controls
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Cancel Button
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context, true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                        // Separator
                      ],
                    ),
                  )
                ]
              : [
                  const Center(
                    child: KinProgressIndicator(),
                  )
                ],
        );
      },
    );
  }
}
