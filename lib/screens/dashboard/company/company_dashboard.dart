import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_graph_card.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_info_card.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({Key? key}) : super(key: key);

  @override
  State<CompanyDashboard> createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> {
  // analytics type
  String currentAnalyticsType = possibleAnalyticTypes[0];

  // upload type
  String currentUploadType = possibleUploadTypesCompany[0];

  // producer drop down values

  List allProducers = [];

  // artists drop down values
  List allArtists = [];

  //  album name
  List allAlbums = [];

  // tracks
  List allTracks = [];

  Map<String, dynamic> userInfo = {};

  Future getAllDropDownValues() async {
    final analyticsProvider =
        Provider.of<AnalyticsProvider>(context, listen: false);

    // get producers
    // allProducers = await analyticsProvider.getAllProducers();

    // // get artists
    // allArtists = await analyticsProvider.getAllArtists();

    // // get albums
    // allAlbums = await analyticsProvider.getAllAlbums();

    // // get tracks
    // allTracks = await analyticsProvider.getAllTracks();

    // // user info
    // userInfo = await analyticsProvider.getLoggedInUserInfo();

    return {
      "producers": allProducers,
      "artists": allArtists,
      "albums": allAlbums,
      "tracks": allTracks,
      "user_info": {
        "name": userInfo['name'],
        "id": userInfo['id'],
        "image": userInfo['image']
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    List displayValues = [];
    String url =
        'https://upload.wikimedia.org/wikipedia/commons/0/0d/Rophnan_Uganda.jpg';

    // producers

    return FutureBuilder(
        future: getAllDropDownValues(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const KinProgressIndicator();
          } else if (snapshot.hasData && !snapshot.hasError) {
            if (currentUploadType == "Producers") {
              displayValues = allProducers;
            }
            // artists
            else if (currentUploadType == "Artists") {
              displayValues = allArtists;
            }

            // albums
            else if (currentUploadType == "Albums") {
              displayValues = allAlbums;
            }
            // tracks
            else if (currentUploadType == "Tracks") {
              displayValues = allTracks;
            } else {
              displayValues = allTracks;
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
              body: SingleChildScrollView(
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
                      // Profile Image
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: Image.asset("assets/images/logo.png"),
                      ),

                      // Spacer
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),

                      // Artist Name
                      Text(
                        userInfo['name'],
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
                        userInfo['email'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getProportionateScreenWidth(14),
                        ),
                      ),

                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),

                      // Info card - Total View Count
                      const ArtistInfoCard(
                        infoLabel: "Total Views",
                        infoValue: "128",
                        cardType: "Views",
                      ),

                      // spacer
                      SizedBox(
                        height: getProportionateScreenHeight(24),
                      ),
                      // Info card - Total View Count
                      const ArtistInfoCard(
                        infoLabel: "Total Revenue",
                        infoValue: "156 ETB",
                        cardType: "Views",
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
                      // InfoGraph(analyticsType: currentAnalyticsType),

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
                              "Your Uploads",
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
                              items: possibleUploadTypesCompany
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
                                    // return ArtistGraphCard(
                                    //   musicCover: displayValues[index]['image'],
                                    //   musicTitle: displayValues[index]['name'],
                                    //   cardType: currentUploadType,
                                    // );
                                    return Container();
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
            );
          } else {
            return Scaffold(
              body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
                child: Text(
                  snapshot.toString(),
                ),
              ),
            );
          }
        });
  }
}

SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 1:
            text = 'week 1';
            break;
          case 4:
            text = 'week 2';
            break;
          case 7:
            text = 'week 3';
            break;
          case 10:
            text = 'week 4';
            break;
        }

        return Text(
          text,
          style: const TextStyle(color: kSecondaryColor),
        );
      },
    );
SideTitles get _lefttitles => SideTitles(
      reservedSize: 30,
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
        switch (value.toInt()) {
          case 1:
            text = '10k';
            break;
          case 2:
            text = '20k';
            break;
          case 3:
            text = '30k';
            break;
          case 4:
            text = '40k';
            break;
          case 5:
            text = '50k';
            break;
          case 6:
            text = '60k';
            break;
        }

        return Text(
          text,
          style: const TextStyle(
            color: kSecondaryColor,
          ),
        );
      },
    );
