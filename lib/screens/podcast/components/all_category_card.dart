import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_list.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class AllCategoryCard extends StatelessWidget {
  const AllCategoryCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.category,
  }) : super(key: key);

  final double width, aspectRatio;
  final PodCastCategory category;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PodcastList(podcasts: category.podcasts)));
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 0),
        height: getProportionateScreenHeight(120),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: category.podcasts.isEmpty
                        ? const AssetImage('assets/images/kin.png')
                            as ImageProvider
                        : CachedNetworkImageProvider(
                            "$apiUrl/${category.podcasts[0]}"),
                    fit: BoxFit.cover)),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(5)),
                        child: Text(
                          category.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: getProportionateScreenHeight(26),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenHeight(5),
                            horizontal: getProportionateScreenWidth(5)),
                        child: Text(
                          '${category.podcasts.length} podcasts',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: getProportionateScreenHeight(15)),
                        ),
                      )
                    ],
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
