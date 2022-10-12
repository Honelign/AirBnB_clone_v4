import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_category.dart';

class PodcastScrollerView extends StatelessWidget {
  PodcastCategory podcastCategory;
  PodcastScrollerView({
    Key? key,
    required this.podcastCategory,
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
            podcastCategory.name,
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
              itemCount: podcastCategory.podcasts.length,
              itemBuilder: ((context, index) {
                return PodcastCard(
                  id: podcastCategory.podcasts[index].id,
                  hostId: podcastCategory.podcasts[index].hostId.toString(),
                  numberOfEpisodes:
                      podcastCategory.podcasts[index].numberOfEpisodes,
                  numberOfSeasons:
                      podcastCategory.podcasts[index].numberOfSeasons,
                  url: podcastCategory.podcasts[index].cover,
                  host: podcastCategory.podcasts[index].hostName,
                  title: podcastCategory.podcasts[index].title,
                  description: podcastCategory.podcasts[index].description,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
