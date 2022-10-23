import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';

import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/screens/genre/components/genre_app_bar.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/genre.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:provider/provider.dart';

class GenreDetail extends StatefulWidget {
  final Genre genre;
  const GenreDetail({Key? key, required this.genre}) : super(key: key);
  static String routName = '/genreDetail';

  @override
  State<GenreDetail> createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {
  late GenreProvider genreProvider;
  static const _pageSize = 1;

  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    genreProvider = Provider.of<GenreProvider>(context, listen: false);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreTracksUnderGenre(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future _fetchMoreTracksUnderGenre({required int pageKey}) async {
    try {
      final newItems = await genreProvider.getAllTracksByGenreId(
          genreId: widget.genre.id.toString(), pageKey: pageKey);
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
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[GenreAppBar(genre: widget.genre)];
          },
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  '$kinAssetBaseUrl/${widget.genre.cover}',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: checkConnection(status) == false
                  ? RefreshIndicator(
                      onRefresh: () async {
                        setState(() {});
                      },
                      color: refreshIndicatorForegroundColor,
                      backgroundColor: refreshIndicatorBackgroundColor,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: const NoConnectionDisplay(),
                      ),
                    )
                  : PagedListView<int, Music>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Music>(
                        animateTransitions: true,
                        transitionDuration: const Duration(milliseconds: 500),
                        noItemsFoundIndicatorBuilder: (context) => SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Text(
                              "No Tracks in ${widget.genre.title}",
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
                              "No More Items in ${widget.genre.title}",
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
                            musics: _pagingController.itemList ?? [],
                            musicIndex: index,
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
