import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/ad_banner.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/components/search/search_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_scroller_view.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

class Podcast extends StatelessWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PodcastProvider podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          decoration: linearGradientDecoration,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                const CustomSearchBar(),

                // Spacer

                const SizedBox(
                  height: 12,
                ),
                // Title
                Text(
                  "PODCASTS",
                  style: headerOneTextStyle,
                ),

                const SizedBox(
                  height: 20,
                ),

                const AdBanner(),

                // Title
                FutureBuilder(
                  future: podcastProvider.getPodcastsByCategory(pageSize: 1),
                  builder: (context, snapshot) {
                    // loading
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: KinProgressIndicator(),
                      );
                    }
                    // data loaded
                    else if (snapshot.hasData && !snapshot.hasError) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.65,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: podcastProvider.podcastCategories.length,
                          itemBuilder: ((context, index) {
                            return PodcastScrollerView(
                              podcastCategory:
                                  podcastProvider.podcastCategories[index],
                            );
                          }),
                        ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
