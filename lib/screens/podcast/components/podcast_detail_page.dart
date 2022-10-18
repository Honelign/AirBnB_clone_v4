import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/about_page.dart';
import 'package:kin_music_player_app/screens/podcast/components/seasons_page.dart';

class PodcastDetailPage extends StatelessWidget {
  String podcastId;
  String podcastName;
  String cover;
  String host;
  String hostId;
  int numberOfSeasons;
  int numberOfEpisodes;
  String description;
  PodcastDetailPage({
    Key? key,
    required this.podcastId,
    required this.podcastName,
    required this.host,
    required this.hostId,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.cover,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          // automaticallyImplyLeading: false,
          backgroundColor: Color(0xFF052C54),
          bottom: TabBar(
            labelColor: kSecondaryColor,
            unselectedLabelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            indicatorPadding: const EdgeInsets.only(
              top: 15,
              bottom: 19,
              left: 50,
              right: 50,
            ),
            indicatorWeight: 5.0,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            //padding: EdgeInsets.symmetric(vertical: 20),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            //  indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: "Detail"),
              Tab(
                text: "Seasons",
              )
            ],
          ),
        ),
        backgroundColor: kPrimaryColor,
        body: TabBarView(
          children: [
            AboutPage(
              cover: cover,
              title: podcastName,
              description:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
              numberOfEpisodes: numberOfEpisodes,
              numberOfSeasons: numberOfSeasons,
              hostName: host,
              hostId: hostId,
            ),
            SeasonsPage(
              id: podcastId,
            ),
          ],
        ),
      ),
    );
  }
}
