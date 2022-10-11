import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/screens/podcast/component/podcast_list_card.dart';
import 'package:kin_music_player_app/services/network/api/podcast_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class AllPodCastList extends StatefulWidget {
  const AllPodCastList({Key? key}) : super(key: key);
  static String routeName = 'allPodCastList';

  @override
  State<AllPodCastList> createState() => _AllPodCastListState();
}

class _AllPodCastListState extends State<AllPodCastList> {
  static const _pageSize = 10;

  final PagingController<int, PodCast> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchMorePodcast(pageKey);
    });
    super.initState();
  }

  Future<void> fetchMorePodcast(pagekey) async {
    List<PodCast> podcasts = [];
    PodcastApiService podcastApiService = PodcastApiService();
    try {
      var page = (pagekey / 10).toInt() + 1;
      podcasts = await podcastApiService.fetchMorePodCasts(page);
      final isLastPage = podcasts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(podcasts);
      } else {
        final nextPageKey = pagekey + podcasts.length;
        _pagingController.appendPage(podcasts, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // 4
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text('Podcast'),
          backgroundColor: Colors.transparent,
        ),
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            // 2
            () => _pagingController.refresh(),
          ),
          backgroundColor: refreshIndicatorBackgroundColor,
          color: refreshIndicatorForegroundColor,
          child: PagedListView<int, PodCast>.separated(
            pagingController: _pagingController,
            shrinkWrap: true,
            builderDelegate: PagedChildBuilderDelegate<PodCast>(
              itemBuilder: (context, podcast, index) => PodCastListCard(
                podCast: podcast,
                podCasts: const [],
              ),
              firstPageErrorIndicatorBuilder: (context) => InkWell(
                child: Text(_pagingController.error),
                onTap: () => _pagingController.refresh(),
              ),
              noMoreItemsIndicatorBuilder: (context) => const Center(
                  child: Text(
                'Reached to the end',
                style: TextStyle(color: Colors.white),
              )),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                  child: Text(
                'None',
                style: TextStyle(color: Colors.white),
              )),
            ),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
            ),
          ),
        ));
  }
}
