import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';

import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../size_config.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> with AutomaticKeepAliveClientMixin {
  late ArtistProvider artistProvider;
  static const _pageSize = 1;
  final PagingController<int, Artist> _pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);
  @override
  void initState() {
    artistProvider = Provider.of<ArtistProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await artistProvider.getArtist(pageSize: pageKey);

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
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      color: refreshIndicatorForegroundColor,
      backgroundColor: refreshIndicatorBackgroundColor,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(30),
        ),
        decoration: linearGradientDecoration,
        child: checkConnection(status) == false
            ? const NoConnectionDisplay()
            : PagedGridView<int, Artist>(
                scrollDirection: Axis.vertical,
                showNoMoreItemsIndicatorAsGridChild: false,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Artist>(
                  animateTransitions: true,
                  transitionDuration: const Duration(milliseconds: 500),
                  noItemsFoundIndicatorBuilder: (context) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: Text("No Artists"),
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
                            "No More Artists",
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
                    return ArtistCard(artist: item);
                  },
                ),
              ),
      ),
    );
  }
}
