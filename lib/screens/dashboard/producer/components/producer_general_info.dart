import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_info_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/daily_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/monthly_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/weekly_graph.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ProducerGeneralInfo extends StatefulWidget {
  const ProducerGeneralInfo({Key? key}) : super(key: key);

  @override
  State<ProducerGeneralInfo> createState() => _ProducerGeneralInfoState();
}

class _ProducerGeneralInfoState extends State<ProducerGeneralInfo>
    with SingleTickerProviderStateMixin {
  String currentAnalyticsType = possibleAnalyticTypes[0];

  int maxCount = 0;
  List<String> dateValues = [];
  List<BarChartGroupData> barData = [];
  List graphDisplayInfo = [];

  late TabController _tabController;

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<List> getProducerGeneralInfo() async {
    AnalyticsProvider analyticsProvider = Provider.of<AnalyticsProvider>(
      context,
      listen: false,
    );
    List result = await analyticsProvider.getProducerGeneralInfo();
    barData = [];
    dateValues = [];

    List statValue;

    if (result.isNotEmpty) {
      if (currentAnalyticsType == "Daily") {
        statValue = result[0].total_daily;
      } else if (currentAnalyticsType == "Weekly") {
        statValue = result[0].total_weekly;
      } else {
        statValue = result[0].total_monthly;
      }
    } else {
      statValue = [];
      barData = [];
      return barData;
    }

    //  find max
    maxCount = int.parse(statValue[0].viewCount);
    int xIndex = 1;
    statValue.forEach((stat) {
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
              color: kSecondaryColor,

              // int.parse(stat.viewCount) > (maxCount * 0.65)
              //     ? kSecondaryColor.withOpacity(0.95)
              //     : int.parse(stat.viewCount) > (maxCount * 0.35)
              //         ? kSecondaryColor.withOpacity(0.75)
              //         : kSecondaryColor.withOpacity(0.55),
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
    });

    return barData;
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsProvider analyticsProvider =
        Provider.of<AnalyticsProvider>(context);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
          currentAnalyticsType = possibleAnalyticTypes[_tabController.index];
        });
      }
    });
    return FutureBuilder<List>(
      future: getProducerGeneralInfo(),
      builder: (context, snapshot) {
        // loafing
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: HeightValues.generalInfoCardHeight,
            child: const Center(
              child: KinProgressIndicator(),
            ),
          );
        }

        // data loaded
        else if (!snapshot.hasError && snapshot.hasData) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: snapshot.data!.isEmpty
                ? 250
                : HeightValues.generalInfoCardHeight,
            child: Column(
              children: [
                // Total Views
                ArtistInfoCard(
                  infoLabel: "Total Views",
                  infoValue: analyticsProvider.generalAnalytics.isEmpty
                      ? "0"
                      : analyticsProvider.generalAnalytics[0].total_count
                          .toString(),
                  cardType: "Views",
                ),

                // spacer
                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),

                // Info card - Total View Count
                ArtistInfoCard(
                  infoLabel: "Total Revenue",
                  infoValue: analyticsProvider.generalAnalytics.isEmpty
                      ? "0 ETB"
                      : analyticsProvider.generalAnalytics[0].total_revenue
                          .toString(),
                  cardType: 'Revenue',
                ),

                // spacer
                SizedBox(
                  height: getProportionateScreenHeight(50),
                ),

                // Line
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 3,
                  color: Colors.grey.withOpacity(0.55),
                ),

                SizedBox(
                  height: getProportionateScreenHeight(20),
                ),

                // analytics one title
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // section title
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Your Music Analytics",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenWidth(
                              18,
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // Spacer
                    const SizedBox(
                      height: 16,
                    ),

                    // General Graph
                    snapshot.data!.isEmpty == true
                        ? const Text(
                            "No Uploads yet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.45,
                            color: Colors.transparent,
                            child: DefaultTabController(
                              length: 3,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: AppBar(
                                  backgroundColor: Colors.transparent,
                                  toolbarHeight: 10,
                                  elevation: 0,
                                  bottom: TabBar(
                                    controller: _tabController,
                                    labelColor: kSecondaryColor,
                                    unselectedLabelColor: Colors.white,
                                    indicator: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    indicatorPadding: const EdgeInsets.only(
                                      top: 15,
                                      bottom: 19,
                                      left: 10,
                                      right: 10,
                                    ),
                                    indicatorWeight: 5.0,
                                    labelStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 0,
                                      vertical: 5,
                                    ),
                                    tabs: const [
                                      Tab(text: "Daily"),
                                      Tab(
                                        text: "Weekly",
                                      ),
                                      Tab(
                                        text: "Monthly",
                                      ),
                                    ],
                                  ),
                                ),
                                body: TabBarView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: HeightValues.graphHeight,
                                      child: DailyGraphWidget(
                                        barData: barData,
                                        bottomTileValues: dateValues,
                                        maxY: maxCount.toDouble(),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: HeightValues.graphHeight,
                                      child: WeeklyGraphWidget(
                                        barData: barData,
                                        maxY: (maxCount.toDouble() + 5),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: HeightValues.graphHeight,
                                      child: MonthlyGraphWidget(
                                        barData: barData,
                                        bottomTileValues: dateValues,
                                        maxY: maxCount.toDouble(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),

                // spacer
              ],
            ),
          );
        }

        // error
        else {
          return OnSnapshotError(error: snapshot.error.toString());
        }
      },
    );
  }
}
