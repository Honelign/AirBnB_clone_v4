import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/artist_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../size_config.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  static const _pageSize = 1;
  final PagingController<int, Artist> _pagingController =
      PagingController(firstPageKey: 1);
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await Provider.of<ArtistProvider>(context, listen: false)
          .getArtist(pageSize: pageKey);

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
    final provider = Provider.of<ArtistProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: Container(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(30)),
        child: PagedGridView<int, Artist>(
          scrollDirection: Axis.vertical,
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
                      "No More Artist",
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

              // GridCard(album: item);
            },
          ),
        ),
      ),
    );
    /* FutureBuilder(
      future: provider.getArtist(),
      builder: (context, AsyncSnapshot<List<Artist>> snapshot) {
        if (snapshot.hasData) {
          List<Artist> artists = snapshot.data!;
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            itemCount: artists.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: getProportionateScreenWidth(25),
              mainAxisSpacing: getProportionateScreenWidth(25),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(25),
              vertical: getProportionateScreenHeight(25),
            ),
            itemBuilder: (context, index) {
              return ArtistCard(artist: artists[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return const Center(
          child: KinProgressIndicator(),
        );
      },
    ); */
  }
}
