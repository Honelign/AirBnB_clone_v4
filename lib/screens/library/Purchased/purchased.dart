import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class Purchased extends StatefulWidget {
  const Purchased({Key? key}) : super(key: key);

  @override
  State<Purchased> createState() => _PurchasedState();
}

class _PurchasedState extends State<Purchased> {
  static const _pageSize = 1;
  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMorePurchasedTracks(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchMorePurchasedTracks(int pageKey) async {
    MusicProvider musicProvider =
        Provider.of<MusicProvider>(context, listen: false);
    try {
      final newItems = await musicProvider.getPurchasedTracks(pageKey: pageKey);

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
    MusicProvider musicProvider =
        Provider.of<MusicProvider>(context, listen: false);
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(
      context,
      listen: false,
    );

    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      backgroundColor: refreshIndicatorBackgroundColor,
      color: refreshIndicatorForegroundColor,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
        child: checkConnection(status) == false
            ? const NoConnectionDisplay()
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
                        "No Purchased Tracks",
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
                  itemBuilder: ((context, item, index) {
                    return MusicListCard(
                      musics: _pagingController.itemList!,
                      music: item,
                      musicIndex: index,
                    );
                  }),
                ),
              ),
      ),
    );
  }
}
