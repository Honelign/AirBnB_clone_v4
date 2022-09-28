import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_info.dart';
import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

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

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        title: Text(widget.playlistName),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
            child: IconButton(
              onPressed: () {
                print("@@@getting tracks");
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
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
            backgroundColor: kSecondaryColor,
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
                      "No Tracks in ${widget.playlistName} - ${widget.playlistId}",
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
                      "No More Items in ${widget.playlistName} - ${widget.playlistId}",
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
                  return MusicListCard(
                    music: item,
                    musics: playListProvider.musics,
                    musicIndex: index,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
