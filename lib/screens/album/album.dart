import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:provider/provider.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
  static const _pageSize = 1;
  final PagingController<int, Album> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchMoreAlbums(pageKey);
      },
    );
    super.initState();
  }

  Future<void> _fetchMoreAlbums(int pageKey) async {
    AlbumProvider albumProvider =
        Provider.of<AlbumProvider>(context, listen: false);
    try {
      final newItems = await albumProvider.getAlbums(pageSize: pageKey);

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
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider =
        Provider.of<AlbumProvider>(context, listen: false);

    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      backgroundColor: refreshIndicatorBackgroundColor,
      color: refreshIndicatorForegroundColor,
      child: Container(
        decoration: linearGradientDecoration,
        child: checkConnection(status) == false
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: linearGradientDecoration,
                child: const NoConnectionDisplay(),
              )
            : Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 2, 30),
                child: Center(
                  child: PagedGridView<int, Album>(
                    scrollDirection: Axis.vertical,
                    showNoMoreItemsIndicatorAsGridChild: false,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 140,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Album>(
                      animateTransitions: true,
                      transitionDuration: const Duration(milliseconds: 500),
                      noItemsFoundIndicatorBuilder: (context) => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const Center(
                          child: Text("No Albums"),
                        ),
                      ),
                      noMoreItemsIndicatorBuilder: (_) => Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(18, 16, 0, 32),
                            width: double.infinity,
                            height: 100,
                            child: const Center(
                              child: Text(
                                "No More Albums",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      firstPageProgressIndicatorBuilder: (_) => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: KinProgressIndicator()),
                      ),
                      newPageProgressIndicatorBuilder: (_) => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: KinProgressIndicator()),
                      ),
                      itemBuilder: (context, item, index) {
                        return GridCard(album: item);
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
