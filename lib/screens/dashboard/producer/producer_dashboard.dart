import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
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

  Future<List> getAllDropDownValues() async {
    try {
      // decide step value

      // initialize provider
      final analyticsProvider = Provider.of<AnalyticsProvider>(
        context,
        listen: false,
      ); // get producer based info
      await analyticsProvider.getProducerOwnedInfo(infoType: currentUploadType);
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
                color: int.parse(stat.viewCount) > (maxCount * 0.65)
                    ? kSecondaryColor.withOpacity(0.95)
                    : int.parse(stat.viewCount) > (maxCount * 0.35)
                        ? kSecondaryColor.withOpacity(0.75)
                        : kSecondaryColor.withOpacity(0.55),
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
    } catch (e) {
      return [];
    }
  }

  // get formatted display name for profile display
  String formatDisplayName() {
    try {
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
    } catch (e) {
      return "";
    }
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

    return Container(
      decoration: linearGradientDecoration,
      child: FutureBuilder<List>(
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

            if (currentAnalyticsType == "Daily" &&
                analyticsProvider.generalAnalytics.isNotEmpty) {
              graphDisplayInfo =
                  analyticsProvider.generalAnalytics[0].total_daily;
            }
            //
            else if (currentAnalyticsType == "Weekly" &&
                analyticsProvider.generalAnalytics.isNotEmpty) {
              graphDisplayInfo =
                  analyticsProvider.generalAnalytics[0].total_weekly;
            }
            //
            else if (currentAnalyticsType == "Monthly" &&
                analyticsProvider.generalAnalytics.isNotEmpty) {
              graphDisplayInfo =
                  analyticsProvider.generalAnalytics[0].total_monthly;
            }
            //
            else if (analyticsProvider.generalAnalytics.isNotEmpty) {
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
                backgroundColor: kSecondaryColor,
                elevation: 0,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                color: refreshIndicatorForegroundColor,
                backgroundColor: refreshIndicatorBackgroundColor,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: linearGradientDecoration,
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
                                      decoration: BoxDecoration(
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
                                  width: 150,
                                  height: 150,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    // color: Colors.grey.withOpacity(0.55),
                                    // image: DecorationImage(
                                    //   image: AssetImage(
                                    //     "assets/images/logo.png",
                                    //   ),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    color: kSecondaryColor.withOpacity(0.65),
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
                            FirebaseAuth.instance.currentUser!.displayName ??
                                "Kin Admin",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(6),
                          ),

                          // Email / contact info
                          Text(
                            getEmailOrPhone(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(
                            height: getProportionateScreenHeight(24),
                          ),

                          snapshot.data!.isEmpty == true
                              ?
                              // if no artists/albums/tracks
                              Column(
                                  children: [
                                    // Info card - Total View Count
                                    ArtistInfoCard(
                                      infoLabel: "Total Views",
                                      infoValue: "0".toString(),
                                      cardType: "Views",
                                    ),

                                    // spacer
                                    SizedBox(
                                      height: getProportionateScreenHeight(24),
                                    ),

                                    // Info card - Total View Count
                                    ArtistInfoCard(
                                      infoLabel: "Total Revenue",
                                      infoValue: "0 ETB".toString(),
                                      cardType: 'Revenue',
                                    ),

                                    // spacer
                                    SizedBox(
                                      height: getProportionateScreenHeight(80),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 5,
                                      color: Colors.grey,
                                    ),

                                    const SizedBox(
                                      height: 24,
                                    ),
                                    // Info Message
                                    const Text(
                                      "No Uploads yet",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              :

                              // info found
                              Column(
                                  children: [
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

                                    // spacer
                                    SizedBox(
                                      height: getProportionateScreenHeight(50),
                                    ),

                                    // Line
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height: 3,
                                      color: Colors.grey.withOpacity(0.55),
                                    ),

                                    SizedBox(
                                      height: getProportionateScreenHeight(20),
                                    ),

                                    // analytics one title
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // section title
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: Text(
                                              "Your Music Analytics",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        24),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 8,
                                        ),

                                        // Dropdown options
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              canvasColor: kSecondaryColor,
                                            ),
                                            child: DropdownButton(
                                              value: currentAnalyticsType,
                                              isExpanded: true,
                                              icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: kSecondaryColor,
                                              ),
                                              // Array list of items
                                              items: possibleAnalyticTypes
                                                  .map((String items) {
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
                                                setState(() {
                                                  currentAnalyticsType =
                                                      newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // spacer
                                    SizedBox(
                                      height: getProportionateScreenHeight(36),
                                    ),

                                    // graph that is dependant of the selected dropdown value
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

                                    // spacer
                                    SizedBox(
                                      height: getProportionateScreenHeight(55),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // section title
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          child: Text(
                                            "Your Views",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  getProportionateScreenWidth(
                                                16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
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
                                              items: possibleUploadTypesProducer
                                                  .map((String items) {
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
                                                    currentUploadType =
                                                        newValue!;
                                                  },
                                                );
                                              },
                                            ),
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
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                // scrollDirection: ,
                                                shrinkWrap: true,
                                                itemCount: displayValues.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ArtistGraphCard(
                                                    id: displayValues[index].id,
                                                    image: displayValues[index]
                                                        .image,
                                                    name: displayValues[index]
                                                        .name,
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
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return OnSnapshotError(
              error: snapshot.error.toString(),
            );
          }
        },
      ),
    );
  }
}
