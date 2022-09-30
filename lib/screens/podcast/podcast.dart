import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_search_screen.dart';

import '../../size_config.dart';

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
      }

      // 13 Months of Sunshine
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
    ];
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Podcasts'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(
              top: getProportionateScreenHeight(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, PodcastSearchScreen.routeName);
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // spacer
              const SizedBox(
                height: 16,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "New Podcasts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // spacer
              const SizedBox(
                height: 16,
              ),

              // main
              PodcastScroller(
                podcasts: podcasts,
              ),

              const SizedBox(
                height: 60,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Popular Podcasts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // spacer
              const SizedBox(
                height: 16,
              ),

              PodcastScroller(
                podcasts: podcastsTwo,
              ),

              const SizedBox(
                height: 60,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Podcast Picks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // spacer
              const SizedBox(
                height: 16,
              ),

              PodcastScroller(
                podcasts: podcastsThree,
              ),

              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PodcastScroller extends StatelessWidget {
  List podcasts;
  PodcastScroller({Key? key, required this.podcasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
          itemCount: podcasts.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              child: PodcastCardGrid(
                podcastName: podcasts[index]['podcast_name'],
                host: podcasts[index]['host'],
                imageUrl: podcasts[index]['image_url'],
              ),
            );
          }),
    );
  }
}

class PodcastCardGrid extends StatelessWidget {
  final String podcastName;
  final String host;
  final String imageUrl;
  const PodcastCardGrid(
      {Key? key,
      required this.podcastName,
      required this.host,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 12, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              podcastName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(
              height: 4,
            ),
            // Host
            Text(
              host,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
