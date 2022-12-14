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
    List podcasts = [
      {
        "podcast_name": "HypheNation: A Diaspora Life",
        "image_url": "assets/images/Podcast-1.jpg",
        "host": "Rebka Fisseha"
      },
      {
        "podcast_name": "Habesha Finance",
        "image_url": "assets/images/Podcast-2.png",
        "host": "Matt G"
      },
      {
        "podcast_name": "The Horn",
        "image_url": "assets/images/Podcast-3.jpg",
        "host": "International Crisis Group"
      },
      {
        "podcast_name": "13 Months of Sunshine",
        "image_url": "assets/images/Podcast-4.jpg",
        "host": "TESFA"
      },

      // 13 Months of Sunshine

      {
        "podcast_name": "MERI Ethiopia",
        "image_url": "assets/images/Podcast-8.jpg",
        "host": "MERI Ethiopia"
      },
      {
        "podcast_name": "Tragedy In Ethiopia",
        "image_url": "assets/images/Podcast-11.jpg",
        "host": "Chris Anderson"
      },
      {
        "podcast_name": "Rorshok Ethiopia Update",
        "image_url": "assets/images/Podcast-5.png",
        "host": "Rorshok"
      },
      {
        "podcast_name": "EBC Ethiopia",
        "image_url": "assets/images/Podcast-10.jpg",
        "host": "Radio"
      },
    ];
    List podcastsTwo = [
      {
        "podcast_name": "Ethiopia by Ane Mitmita",
        "image_url": "assets/images/Podcast-9.jpg",
        "host": "Ane Mitmia"
      },
      {
        "podcast_name": "TARIK: The Ethiopian History Podcast",
        "image_url": "assets/images/Podcast-10.jpg",
        "host": "T A R I K"
      },
      {
        "podcast_name": "Tragedy In Ethiopia",
        "image_url": "assets/images/Podcast-11.jpg",
        "host": "Chris Anderson"
      },
      {
        "podcast_name": "MIInDs Ethiopia",
        "image_url": "assets/images/Podcast-6.jpg",
        "host": "MIInDs"
      },
      {
        "podcast_name": "EBC Ethiopia",
        "image_url": "assets/images/Podcast-7.jpg",
        "host": "Radio"
      },
      {
        "podcast_name": "MERI Ethiopia",
        "image_url": "assets/images/Podcast-8.jpg",
        "host": "MERI Ethiopia"
      },
      {
        "podcast_name": "Tragedy In Ethiopia",
        "image_url": "assets/images/Podcast-11.jpg",
        "host": "Chris Anderson"
      },
      {
        "podcast_name": "Rorshok Ethiopia Update",
        "image_url": "assets/images/Podcast-5.png",
        "host": "Rorshok"
      },
      {
        "podcast_name": "EBC Ethiopia",
        "image_url": "assets/images/Podcast-10.jpg",
        "host": "Radio"
      },
    ];
    List podcastsThree = [
      {
        "podcast_name": "MERI Ethiopia",
        "image_url": "assets/images/Podcast-8.jpg",
        "host": "MERI Ethiopia"
      },
      {
        "podcast_name": "Tragedy In Ethiopia",
        "image_url": "assets/images/Podcast-11.jpg",
        "host": "Chris Anderson"
      },
      {
        "podcast_name": "Rorshok Ethiopia Update",
        "image_url": "assets/images/Podcast-5.png",
        "host": "Rorshok"
      },
      {
        "podcast_name": "EBC Ethiopia",
        "image_url": "assets/images/Podcast-10.jpg",
        "host": "Radio"
      },
      {
        "podcast_name": "Ethiopia by Ane Mitmita",
        "image_url": "assets/images/Podcast-9.jpg",
        "host": "Ane Mitmia"
      },
      {
        "podcast_name": "TARIK: The Ethiopian History Podcast",
        "image_url": "assets/images/Podcast-10.jpg",
        "host": "T A R I K"
      },
      {
        "podcast_name": "Tragedy In Ethiopia",
        "image_url": "assets/images/Podcast-11.jpg",
        "host": "Chris Anderson"
      },
      {
        "podcast_name": "MIInDs Ethiopia",
        "image_url": "assets/images/Podcast-6.jpg",
        "host": "MIInDs"
      },
      {
        "podcast_name": "EBC Ethiopia",
        "image_url": "assets/images/Podcast-7.jpg",
        "host": "Radio"
      },
    ];
    List allPodcasts = [
      podcasts,
      podcastsTwo,
      podcastsThree,
      podcasts,
      podcastsTwo,
      podcastsThree,
      podcasts,
      podcastsTwo,
      podcastsThree,
      podcasts,
      podcastsTwo,
      podcastsThree
    ];

    PodcastProvider podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: linearGradientDecoration,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                CustomSearchBar(),

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

                AdBanner(),

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
