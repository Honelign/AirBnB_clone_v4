import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/screens/podcast/component/all_podcasts.dart';
import 'package:kin_music_player_app/screens/podcast/component/podcast_card.dart';

import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class PopularPodcasts extends StatelessWidget {
  const PopularPodcasts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodCastProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular PodCasts",
              press: () {
                Navigator.pushNamed(context, AllPodCastList.routeName);
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        SizedBox(
          height: getProportionateScreenHeight(300),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: provider.getPopularPodCast(),
              builder: (context, AsyncSnapshot<List<PodCast>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<PodCast> podcasts = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data == null
                          ? 0
                          : (snapshot.data!.length > 5
                              ? 5
                              : snapshot.data!.length),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return PodcastCard(
                            podcast: podcasts[index], podcasts: podcasts);
                      },
                    );
                  } else {
                    return Container(
                      margin:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.35),
                      child: Center(
                        child: Text(
                          "No Data Available",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
                  //  padding:  EdgeInsets.only(right: getProportionateScreenWidth(2)),

                  child: const Center(
                    child: KinProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
