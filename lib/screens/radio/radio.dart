import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/components/search/search_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/radio/components/radio_grid.dart';
import 'package:kin_music_player_app/screens/radio/components/radio_list_card.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

class RadioScreenNew extends StatelessWidget {
  const RadioScreenNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RadioProvider radioProvider = Provider.of<RadioProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                kSecondaryColor,
                Color(0xFFF5F5F5),
              ],
            ),
          ),
          child: FutureBuilder<List<RadioStation>>(
            future: radioProvider.getStations(),
            builder: (context, snapshot) {
              // loading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: KinProgressIndicator(),
                );
              }

              // data loaded
              else if (snapshot.hasData && !snapshot.hasError) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    const CustomSearchBar(),

                    // Spacer
                    const SizedBox(
                      height: 200,
                    ),
                    // Title
                    Text(
                      "RADIO",
                      style: headerOneTextStyle,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    _buildAdBanner(context: context),

                    // Spacer
                    const SizedBox(
                      height: 18,
                    ),

                    _buildRecentlyPlayed(
                      context: context,
                      recentlyPlayedStations: snapshot.data!,
                    ),

                    // Spacer
                    const SizedBox(
                      height: 18,
                    ),

                    _buildAppStations(
                      context: context,
                      radioStations: snapshot.data!,
                    ),
                  ],
                );
              }

              // error
              else {
                return OnSnapshotError(
                  error: snapshot.error.toString(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildAdBanner({required BuildContext context}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 70,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Ad Banner.png"),
        ),
      ),
    ),
  );
}

Widget _buildRecentlyPlayed(
    {required BuildContext context,
    required List<RadioStation> recentlyPlayedStations}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title
      Text(
        "Recently Played",
        style: headerTwoTextStyle,
      ),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 106,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return RadioCardGrid(
              station: recentlyPlayedStations[index],
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildAppStations(
    {required BuildContext context,
    required List<RadioStation> radioStations}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          "All Stations",
          style: headerThreeTextStyle,
        ),

        const SizedBox(
          height: 8,
        ),

        SizedBox(
          height: (MediaQuery.of(context).size.height * 0.45),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: radioStations.length,
            itemBuilder: (context, index) {
              return RadioCardList(
                station: radioStations[index],
              );
            },
          ),
        )
      ],
    ),
  );
}
