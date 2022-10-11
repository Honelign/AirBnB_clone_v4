import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_card.dart';

class PodcastScrollerView extends StatelessWidget {
  List allPodcasts;
  PodcastScrollerView({
    Key? key,
    required this.allPodcasts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Title",
            style: headerTextStyle,
          ),

          const SizedBox(
            height: 8,
          ),

          //  card container
          SizedBox(
            height: 175,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allPodcasts.length,
              itemBuilder: ((context, index) {
                return PodcastCard(
                  url: allPodcasts[index]['image_url'],
                  host: allPodcasts[index]['host'],
                  title: allPodcasts[index]['podcast_name'],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
