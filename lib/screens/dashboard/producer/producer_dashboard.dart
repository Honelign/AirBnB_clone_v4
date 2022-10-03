import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_graph_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_info_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/daily_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/monthly_graph.dart';
import 'package:kin_music_player_app/screens/dashboard/components/graphs/weekly_graph.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ProducerDashboard extends StatefulWidget {
  const ProducerDashboard({Key? key}) : super(key: key);

  @override
  State<ProducerDashboard> createState() => _ProducerDashboardState();
}

class _ProducerDashboardState extends State<ProducerDashboard> {
  int maxCount = 0;
  List<String> dateValues = [];
  //
  List<BarChartGroupData> barData = [];

  // analytics type
  String currentAnalyticsType = possibleAnalyticTypes[0];
  List graphDisplayInfo = [];

  // upload type
  String currentUploadType = possibleUploadTypesProducer[0];

  Future getAllDropDownValues() async {
    // decide step value

    // initialize provider
    final analyticsProvider = Provider.of<AnalyticsProvider>(
      context,
      listen: false,
    ); // get producer based info

    await analyticsProvider.getProducerOwnedInfo(typeOfInfo: currentUploadType);

    List result = await analyticsProvider.getProducerGeneralInfo();
    barData = [];
    dateValues = [];

    List statValue;

    if (currentAnalyticsType == "Daily") {
      statValue = result[0].total_daily;
    } else if (currentAnalyticsType == "Weekly") {
      statValue = result[0].total_weekly;
    } else {
      statValue = result[0].total_monthly;
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
    });

    return {};
  }

  // get formatted display name for profile display
  String formatDisplayName() {
    var currentUser = FirebaseAuth.instance.currentUser;
    String displayValue = "PD";
    if (currentUser != null) {
      String firstName = currentUser.displayName!.split(" ")[0];
      String lastName = currentUser.displayName!.split(" ")[1];

      if (firstName != null && lastName != null) {
        displayValue = firstName[0] + lastName[0];
      } else if (firstName != null) {
        displayValue = firstName[0] + firstName[1];
      } else if (lastName != null) {
        displayValue = lastName[0] + lastName[1];
      }
    }

    return displayValue;
  }

  // get phone or email to display
  String getEmailOrPhone() {
    String displayValue = "";
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      if (currentUser.email != "") {
        displayValue = currentUser.email ?? "";
      } else if (currentUser.phoneNumber != "") {
        displayValue = currentUser.phoneNumber ?? "";
      }
    }

    return displayValue;
  }

  @override
  Widget build(BuildContext context) {
    List displayValues = [];

    return FutureBuilder(
      future: getAllDropDownValues(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const KinProgressIndicator();
        } else if (snapshot.hasData && !snapshot.hasError) {
          final analyticsProvider =
              Provider.of<AnalyticsProvider>(context, listen: false);
          // artists
          if (currentUploadType == "Artists") {
            displayValues = analyticsProvider.allArtists;
          }

          // albums
          else if (currentUploadType == "Albums") {
            displayValues = analyticsProvider.allAlbums;
          }
          // tracks
          else if (currentUploadType == "Tracks") {
            displayValues = analyticsProvider.allTracks;
          } else {
            displayValues = analyticsProvider.allTracks;
          }

          if (currentAnalyticsType == "Daily") {
            graphDisplayInfo =
                analyticsProvider.generalAnalytics[0].total_daily;
          }
          //
          else if (currentAnalyticsType == "Weekly") {
            graphDisplayInfo =
                analyticsProvider.generalAnalytics[0].total_weekly;
          }
          //
          else if (currentAnalyticsType == "Monthly") {
            graphDisplayInfo =
                analyticsProvider.generalAnalytics[0].total_monthly;
          }
          //
          else {
            graphDisplayInfo =
                analyticsProvider.generalAnalytics[0].total_daily;
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
              ),
              backgroundColor: Colors.black,
            ),
            backgroundColor: Colors.black,
            body: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              color: refreshIndicatorForegroundColor,
              backgroundColor: refreshIndicatorBackgroundColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    getProportionateScreenWidth(16),
                    getProportionateScreenHeight(40),
                    getProportionateScreenWidth(16),
                    getProportionateScreenHeight(40),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //  profile image
                      FirebaseAuth.instance.currentUser!.photoURL != null
                          ? SizedBox(
                              width: 120,
                              height: 120,
                              child: CachedNetworkImage(
                                imageUrl: FirebaseAuth
                                        .instance.currentUser!.photoURL ??
                                    "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  // height: 200,
                                  //  width: double.infinity,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(20),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(0.55),
                              ),
                              child: Center(
                                child: Text(
                                  formatDisplayName(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 64,
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                            ),

                      // Spacer
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),

                      // Artist Name
                      Text(
                        FirebaseAuth.instance.currentUser!.displayName ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(28),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(6),
                      ),

                      // Email / contact info
                      Text(
                        getEmailOrPhone(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),

                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),

                      // Info card - Total View Count
                      ArtistInfoCard(
                        infoLabel: "Total Views",
                        infoValue: analyticsProvider
                            .generalAnalytics[0].total_count
                            .toString(),
                        cardType: "Views",
                      ),

                      // spacer
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),
                      // Info card - Total View Count
                      ArtistInfoCard(
                        infoLabel: "Total Revenue",
                        infoValue: analyticsProvider
                            .generalAnalytics[0].total_revenue
                            .toString(),
                        cardType: 'Revenue',
                      ),

                      SizedBox(
                        height: getProportionateScreenHeight(45),
                      ),

                      // analytics one title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // section title
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: Text(
                              "Your Music Analytics",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
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
                              items: possibleAnalyticTypes.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: const TextStyle(color: Colors.white),
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

                      SizedBox(
                        height: getProportionateScreenHeight(36),
                      ),

                      // Graph Section
                      // currentAnalyticsType == "Daily"
                      //     ? DailyGraph(
                      //         barData: finalValues,
                      //         leftTileValues: [],
                      //         bottomTileValues: mainGraphInfo
                      //             .map(
                      //               (e) => e['date'] as String,
                      //             )
                      //             .toList(),
                      //       )
                      //     : currentAnalyticsType == "Weekly"
                      //         ? WeeklyGraph(
                      //             barData: finalValues,
                      //             leftTileValues: [],
                      //             bottomTileValues: const [
                      //               "Week 1",
                      //               "Week 2",
                      //               "Week 3",
                      //               "Week 4"
                      //             ],
                      //           )
                      //         : MonthlyGraph(
                      //             barData: finalValues,
                      //             leftTileValues: [],
                      //             bottomTileValues: mainGraphInfo
                      //                 .map(
                      //                   (e) => e['date'] as String,
                      //                 )
                      //                 .toList(),
                      //           ),

                      //
                      currentAnalyticsType == "Daily"
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

                      SizedBox(
                        height: getProportionateScreenHeight(55),
                      ),

                      Row(
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
                                fontSize: getProportionateScreenWidth(16),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DropdownButton(
                              value: currentUploadType,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: kSecondaryColor,
                              ),
                              // Array list of items
                              items: possibleUploadTypesProducer
                                  .map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(
                                  () {
                                    currentUploadType = newValue!;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        width: double.infinity,
                        height: getProportionateScreenHeight(300),
                        child: displayValues.isNotEmpty
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // scrollDirection: ,
                                  shrinkWrap: true,
                                  itemCount: displayValues.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ArtistGraphCard(
                                      id: displayValues[index].id,
                                      image: displayValues[index].image,
                                      name: displayValues[index].name,
                                      cardType: currentUploadType,
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  "No $currentUploadType uploaded",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
              child: Column(
                children: [
                  Text(
                    snapshot.toString(),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    color: Colors.red,
                    child: InkWell(
                      child: const Text("Back"),
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
