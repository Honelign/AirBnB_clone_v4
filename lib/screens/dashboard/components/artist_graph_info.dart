import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_info_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/daily_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/monthly_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/weekly_graph.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ArtistGraphPage extends StatefulWidget {
  final String artistId;
  final String artistName;
  final String artistCover;

  const ArtistGraphPage({
    Key? key,
    required this.artistId,
    required this.artistName,
    required this.artistCover,
  }) : super(key: key);

  @override
  State<ArtistGraphPage> createState() => _ArtistGraphPageState();
}

class _ArtistGraphPageState extends State<ArtistGraphPage> {
  String currentAnalyticsType = 'Daily';
  var possibleAnalyticTypes = [
    'Daily',
    'Weekly',
    'Monthly',
  ];

  // if (cardType == "Track") {
  List trackAnalytics = [];

  int maxCount = 0;
  List<String> dateValues = [];
  List<BarChartGroupData> barData = [];

  Future getInfoValues() async {
    List statValue;
    barData = [];
    dateValues = [];

    final provider = Provider.of<AnalyticsProvider>(context, listen: false);
    trackAnalytics =
        await provider.getArtistAnalyticsInfo(artistId: widget.artistId);

    if (trackAnalytics.isEmpty) {
      return {"status": "empty"};
    }
    if (currentAnalyticsType == "Daily") {
      statValue = trackAnalytics[0].total_daily;
    } else if (currentAnalyticsType == "Weekly") {
      statValue = trackAnalytics[0].total_weekly;
    } else {
      statValue = trackAnalytics[0].total_monthly;
    }

    //  find max
    maxCount = int.parse(statValue[0].viewCount);
    int xIndex = 1;
    for (var stat in statValue) {
      if (int.parse(stat.viewCount) > maxCount) {
        maxCount = int.parse(stat.viewCount);
      }
      barData.add(
        BarChartGroupData(
          x: xIndex,
          barRods: [
            BarChartRodData(
              fromY: 0,
              toY: int.parse(stat.viewCount).toDouble(),
              width: 15,
              color: int.parse(stat.viewCount) > maxCount * 0.65
                  ? Colors.green
                  : int.parse(stat.viewCount) > maxCount * 0.35
                      ? Colors.yellow
                      : Colors.red,
            ),
          ],
        ),
      );

      String dateFormatterString =
          currentAnalyticsType == "Daily" ? "EEEE" : "MMM";

      var formattedDate = DateFormat(dateFormatterString).format(
        DateTime.parse(
          stat.viewTimeLine,
        ),
      );
      dateValues.add(formattedDate.substring(0, 3));

      xIndex++;
    }

    return {"status": "done"};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getInfoValues(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const KinProgressIndicator();
          } else if (snapshot.hasData && !snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: kPrimaryColor,
                title: Text(widget.artistName.toString()),
              ),
              body: Container(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(40),
                  horizontal: getProportionateScreenWidth(10),
                ),
                height: MediaQuery.of(context).size.height,
                color: kPrimaryColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  "$kinAssetBaseUrl/${widget.artistCover}",
                                ),
                                fit: BoxFit.fill,
                              ),
                            ),
                            width: getProportionateScreenWidth(120),
                            height: getProportionateScreenHeight(120),
                          ),
                          // SizedBox(
                          //   width: getProportionateScreenWidth(20),
                          // ),
                          // drop down
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                      ),
                      ArtistInfoCard(
                        infoLabel: "Total Views",
                        infoValue: trackAnalytics[0].total_count.toString(),
                        cardType: "Views",
                      ),
                      // spacer
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),
                      ArtistInfoCard(
                        infoLabel: "Total Revenue",
                        infoValue: trackAnalytics[0].total_revenue.toString(),
                        cardType: "Revenue",
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: DropdownButton(
                                value: currentAnalyticsType,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: kSecondaryColor,
                                ),
                                // Array list of items
                                items:
                                    possibleAnalyticTypes.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(
                                      items,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    currentAnalyticsType = newValue!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(50),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        color: kPrimaryColor,
                        // child: InfoGraph(analyticsType: currentAnalyticsType),
                        child: barData.isEmpty == true
                            ? const Center(
                                child: Text(
                                  "No Views Yet",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : currentAnalyticsType == "Daily"
                                ? DailyGraphWidget(
                                    barData: barData,
                                    bottomTileValues: dateValues,
                                    maxY: maxCount.toDouble(),
                                  )
                                : currentAnalyticsType == "Weekly"
                                    ? WeeklyGraphWidget(
                                        barData: barData,
                                        maxY: (maxCount.toDouble() + 5),
                                      )
                                    : MonthlyGraphWidget(
                                        barData: barData,
                                        bottomTileValues: dateValues,
                                        maxY: maxCount.toDouble(),
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(body: Text(snapshot.toString()));
          }
        }));
  }
}
