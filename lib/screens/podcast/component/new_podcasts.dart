import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/screens/podcast/component/detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class NewPodcasts extends StatelessWidget {
  const NewPodcasts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PodCastProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: const Text(
            'New Podcast',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SizedBox(
          height: getProportionateScreenHeight(120),
          child: FutureBuilder(
            future: provider.getPodCast(),
            builder: (context, AsyncSnapshot<List<PodCast>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<PodCast>? podcast = snapshot.data;
                  return ListView.builder(
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: podcast!.length > 3 ? 3 : podcast.length,
                      itemBuilder: (context, index) {
                        return NewPodcastCard(
                            image:
                                "$kinAssetsBaseUrlOld/${podcast[index].cover}",
                            podcast: podcast[index].narrator,
                            numOfEpisodes: podcast[index].episodes.length,
                            press: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Detail(
                                        podCast: podcast[index],
                                      )));
                            });
                        // SizedBox(width: getProportionateScreenWidth(20))
                      });
                } else {
                  return Container(
                    child: Center(
                      child: Text(
                        "No Data Available",
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  );
                }
              }
              return Center(
                child: KinProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class NewPodcastCard extends StatelessWidget {
  const NewPodcastCard({
    Key? key,
    required this.podcast,
    required this.image,
    required this.numOfEpisodes,
    required this.press,
  }) : super(key: key);

  final String podcast, image;
  final int numOfEpisodes;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                CachedNetworkImage(
                    imageUrl: image, fit: BoxFit.cover, width: double.infinity),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.3),
                        const Color(0xFF343434).withOpacity(0.45),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "By $podcast\n",
                          style: const TextStyle(
                            fontSize: 18,
                            color: kSecondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfEpisodes episodes")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
