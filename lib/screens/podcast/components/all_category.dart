import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/all_category_card.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';

class AllCategory extends StatefulWidget {
  const AllCategory({Key? key}) : super(key: key);
  static String routeName = '/allCategory';

  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  static const _pageSize = 10;

  final PagingController<int, PodCastCategory> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchMoreCategory(pageKey);
    });
    super.initState();
  }

  Future<void> fetchMoreCategory(pageKey) async {
    List<PodCastCategory> categories = [];
    try {
      var page = (pageKey / 10).toInt() + 1;
      categories = await fetchMoreCategories(page);
      final isLastPage = categories.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(categories);
      } else {
        final nextPageKey = pageKey + categories.length;
        _pagingController.appendPage(categories, nextPageKey);
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
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.15),
        appBar: AppBar(
          title: const Text('All Category'),
          backgroundColor: Colors.black.withOpacity(0.54),
          elevation: 2,
        ),
        body: RefreshIndicator(
            onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
                ),
            backgroundColor: refreshIndicatorBackgroundColor,
            color: refreshIndicatorForegroundColor,
            child: PagedListView<int, PodCastCategory>.separated(
              pagingController: _pagingController,
              shrinkWrap: true,
              builderDelegate: PagedChildBuilderDelegate<PodCastCategory>(
                itemBuilder: (context, category, index) =>
                    AllCategoryCard(category: category),
                noMoreItemsIndicatorBuilder: (context) => const Center(
                    child: Text(
                  'Reached to the end',
                  style: TextStyle(color: Colors.white),
                )),
                firstPageErrorIndicatorBuilder: (context) => InkWell(
                  child: Text(
                    _pagingController.error,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _pagingController.refresh(),
                ),
                noItemsFoundIndicatorBuilder: (context) => const Center(
                    child: Text(
                  'None',
                  style: TextStyle(color: Colors.white),
                )),
              ),
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, int index) =>
                  const Divider(thickness: 1),
            )));
  }
}
