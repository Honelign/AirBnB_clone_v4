import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PodcastList extends StatelessWidget {
  List<PodCastEpisode> podcasts;

  PodcastList({Key? key, required this.podcasts}) : super(key: key);
  static String routeName = 'podcastName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text('Podcast'),
          backgroundColor: Colors.transparent,
        ),
        body: GridView.builder(
            itemCount: podcasts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: getProportionateScreenWidth(25)),
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenHeight(35),
                vertical: getProportionateScreenHeight(25)),
            itemBuilder: (context, index) {
              // return PodcastCard(podcast: podcasts![index], podcasts: podcasts);
              return Text(
                podcasts[0].toString(),
                style: TextStyle(color: Colors.red),
              );
            }));
  }
}
