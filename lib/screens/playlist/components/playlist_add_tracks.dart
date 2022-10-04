import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_select_card.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/multi_select_provider.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:provider/provider.dart';

class AddTracksToPlaylist extends StatefulWidget {
  final String playlistName;
  final String playlistId;
  final Function refresherFunction;
  const AddTracksToPlaylist({
    Key? key,
    required this.playlistName,
    required this.playlistId,
    required this.refresherFunction,
  }) : super(key: key);

  @override
  State<AddTracksToPlaylist> createState() => _AddTracksToPlaylistState();
}

class _AddTracksToPlaylistState extends State<AddTracksToPlaylist> {
  late MusicProvider musicProvider;
  late PlayListProvider playlistProvider;
  late MultiSelectProvider multiSelectProvider;

  static const _pageSize = 1;
  int selectedCount = 0;

  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    musicProvider = Provider.of<MusicProvider>(context, listen: false);
    multiSelectProvider =
        Provider.of<MultiSelectProvider>(context, listen: false);
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreTracks(pageKey: pageKey);
    });
    super.initState();
  }

  Future _fetchMoreTracks({required int pageKey}) async {
    try {
      final newItems = await musicProvider.getNewMusics(pageKey: pageKey);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<MultiSelectProvider>(
      builder: ((context, multiSelectProvider, child) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 100,
            backgroundColor: kPrimaryColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text("Add to ${widget.playlistName}"),

                // spacer
                const SizedBox(
                  height: 4,
                ),

                // Info display
                multiSelectProvider.selectModeSelectedMusicIds.isEmpty
                    ? const Text(
                        "Multiple Select",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    : Text(
                        multiSelectProvider.selectModeSelectedMusicIds.length ==
                                1
                            ? "1 item selected"
                            : "${multiSelectProvider.selectModeSelectedMusicIds.length} items selected",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      )
              ],
            ),
            actions: [
              //  Save Button
              multiSelectProvider.selectModeSelectedMusicIds.isNotEmpty
                  ? IconButton(
                      onPressed: () async {
                        playlistProvider.isLoading = true;
                        setState(() {});

                        bool saveStatus =
                            await playlistProvider.addMultipleMusicToPlaylist(
                          playlistId: widget.playlistId,
                          musicIds:
                              multiSelectProvider.selectModeSelectedMusicIds,
                        );
                        playlistProvider.isLoading = false;

                        if (saveStatus == true) {
                          multiSelectProvider.cancelAllSelection();
                          await playlistProvider.getTracksUnderPlaylistById(
                            playlistId: int.parse(
                              widget.playlistId.toString(),
                            ),
                          );
                          setState(() {});
                          widget.refresherFunction();
                          kShowToast(
                              message:
                                  "Successfully added to ${widget.playlistName}");
                          Navigator.pop(context, false);
                        } else {
                          kShowToast(
                              message:
                                  "Could not add to ${widget.playlistName}");
                        }
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                    )
                  : Container(),

              // Cancel Button
              multiSelectProvider.selectModeSelectedMusicIds.isNotEmpty
                  ? IconButton(
                      onPressed: () async {
                        await multiSelectProvider.cancelAllSelection();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ],
          ),
          backgroundColor: kPrimaryColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                _pagingController.refresh();
              },
              backgroundColor: refreshIndicatorBackgroundColor,
              color: refreshIndicatorForegroundColor,
              child: multiSelectProvider.isLoading ||
                      playlistProvider.isLoading == true
                  ? const Center(
                      child: KinProgressIndicator(),
                    )
                  : PagedListView<int, Music>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Music>(
                        animateTransitions: true,
                        transitionDuration: const Duration(milliseconds: 500),
                        noItemsFoundIndicatorBuilder: (context) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: const Center(
                            child: Text(
                              "No Tracks",
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
                              "No More Tracks",
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
                        itemBuilder: (context, item, index) {
                          // check if music is selected
                          List<String> filtered = multiSelectProvider
                              .selectModeSelectedMusicIds
                              .where((element) =>
                                  element.toString() == item.id.toString())
                              .toList();

                          return InkWell(
                            onTap: () async {
                              await multiSelectProvider.addMusicToSelectedList(
                                musicId: item.id.toString(),
                              );
                              setState(() {});
                            },
                            child: PlaylistSelectCard(
                              music: item,
                              musics: musicProvider.albumMusics,
                              musicIndex: index,
                              isMusicSelected:
                                  filtered.isEmpty == true ? false : true,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        );
      }),
    );
  }
}
