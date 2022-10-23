import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_graph_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/monthly_graph.dart';
import 'package:kin_music_player_app/services/network/model/analytics/analytics_info.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ProducerOwnedInfo extends StatefulWidget {
  const ProducerOwnedInfo({Key? key}) : super(key: key);

  @override
  State<ProducerOwnedInfo> createState() => _ProducerOwnedInfoState();
}

class _ProducerOwnedInfoState extends State<ProducerOwnedInfo> {
  String currentUploadType = possibleUploadTypesProducer[0];
  late AnalyticsProvider analyticsProvider;
  static const _pageSize = 1;
  final PagingController<int, AnalyticsInfo> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    analyticsProvider = Provider.of<AnalyticsProvider>(context, listen: false);

    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreAnalyticsInfo(pageKey: pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future _fetchMoreAnalyticsInfo({required int pageKey}) async {
    try {
      final newItems = await analyticsProvider.getProducerOwnedInfo(
        infoType: currentUploadType,
        page: pageKey,
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
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.60,
      color: Colors.transparent,
      child: Column(
        children: [
          // Dropdown
          Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // section title
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    "Your Views",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(
                        16,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: kSecondaryColor,
                    ),
                    child: DropdownButton(
                      value: currentUploadType,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: kSecondaryColor,
                      ),
                      // Array list of items
                      items: possibleUploadTypesProducer.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(
                            items,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(
                          () {
                            currentUploadType = newValue!;
                          },
                        );

                        _pagingController.refresh();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Contain
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.60 - 60,
            child: PagedListView<int, AnalyticsInfo>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<AnalyticsInfo>(
                animateTransitions: true,
                transitionDuration: const Duration(milliseconds: 500),
                noItemsFoundIndicatorBuilder: (context) => SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Center(
                    child: Text(
                      "No  $currentUploadType",
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
                      "No More  $currentUploadType",
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
                  return ArtistGraphCard(
                    id: item.id,
                    image: item.image,
                    name: item.name,
                    cardType: currentUploadType,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
