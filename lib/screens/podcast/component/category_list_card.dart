import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/component/podcast_list.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';

import '../../../size_config.dart';

class CategoryListCard extends StatelessWidget {
  final PodCastCategory category;

  const CategoryListCard({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PodcastList(podcasts: category.podcasts)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenHeight(10),
            vertical: getProportionateScreenWidth(8)),
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(12),
            vertical: getProportionateScreenHeight(8)),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.white.withOpacity(
                  0.6,
                ),
                width: 1),
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50)),
        child: Text(
          category.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
