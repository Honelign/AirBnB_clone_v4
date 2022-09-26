import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/genre_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class Genres extends StatefulWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> with AutomaticKeepAliveClientMixin {
  late GenreProvider genreProvider;
  static const _pageSize = 1;
  final PagingController<int, Genre> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    genreProvider = Provider.of<GenreProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreGenre(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchMoreGenre(int pageKey) async {
    try {
      final newItems = await genreProvider.getAllGenres(pageKey: pageKey);
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
    super.build(context);
    return RefreshIndicator(
      color: kSecondaryColor,
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedGridView<int, Genre>(
        pagingController: _pagingController,
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(10),
          vertical: getProportionateScreenHeight(25),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
          crossAxisSpacing: getProportionateScreenWidth(15),
          mainAxisSpacing: 20,
        ),
        builderDelegate: PagedChildBuilderDelegate(
          animateTransitions: true,
          transitionDuration: const Duration(milliseconds: 500),
          noItemsFoundIndicatorBuilder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text("No Genres"),
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
                    "No More Genres",
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
          itemBuilder: ((context, item, index) {
            return GenreCard(
              genre: item,
            );
          }),
        ),
      ),
    );
  }
}
