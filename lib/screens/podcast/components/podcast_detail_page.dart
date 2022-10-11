import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/about_page.dart';
import 'package:kin_music_player_app/screens/podcast/components/seasons_page.dart';

class PodcastDetailPage extends StatelessWidget {
  String podcastId;
  String podcastName;
  PodcastDetailPage(
      {Key? key, required this.podcastId, required this.podcastName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          bottom: const TabBar(
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: kSecondaryColor,
            tabs: [
              Tab(text: "Detail"),
              Tab(
                text: "Seasons",
              )
            ],
          ),
        ),
        backgroundColor: kPrimaryColor,
        body: const TabBarView(
          children: [
            AboutPage(),
            SeasonsPage(),
          ],
        ),
      ),
    );
  }
}
