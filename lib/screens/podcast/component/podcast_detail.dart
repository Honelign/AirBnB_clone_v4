import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/component/custom_list_tile.dart';
import 'package:kin_music_player_app/screens/podcast/component/detail_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/size_config.dart';

class PodcastDetail extends StatelessWidget {
  final PodCast podCast;

  const PodcastDetail({Key? key, required this.podCast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  '$kinAssetsBaseUrlOld/${podCast.cover}'),
              fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: getProportionateScreenHeight(30),
            ),
            buildDescription(context, podCast),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            buildCreator(context, podCast),
            SizedBox(
              height: getProportionateScreenHeight(25),
            ),
            DetailCard(podCast: podCast)
          ],
        ),
      ),
    );
  }

  Widget buildDescription(BuildContext context, PodCast podCast) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Description',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Text(
              podCast.description!,
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCreator(BuildContext context, PodCast podCast) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Creators',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: getProportionateScreenHeight(10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10)),
            child: Text(
              podCast.narrator,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(
            height: getProportionateScreenHeight(5),
          ),
        ],
      ),
    );
  }

  Widget buildDetail(BuildContext context, PodCast podCast) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenHeight(15)),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomListTile(
              title: 'Duration',
              // data: "${podCast.duration} min",
              data: "10 min",
              iconData: Icons.timelapse,
              color: Colors.white.withOpacity(0.75)),
          SizedBox(
            width: getProportionateScreenWidth(25),
          ),
          CustomListTile(
              title: 'Episodes',
              data: '${podCast.episodes.length}',
              iconData: Icons.ondemand_video,
              color: Colors.white.withOpacity(0.75))
        ],
      ),
    );
  }
}
