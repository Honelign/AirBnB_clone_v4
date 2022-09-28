import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/size_config.dart';

class GenreAppBar extends StatelessWidget {
  final Genre genre;
  const GenreAppBar({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 175,
      pinned: true,
      backgroundColor: kPrimaryColor,
      elevation: 2,
      title: const Text('Musics'),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 75),
        child: Container(
          alignment: Alignment.centerLeft,
          width: double.infinity,
          color: kGrey.withOpacity(0.3),
          height: getProportionateScreenHeight(75),
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: Text(
            genre.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: "$kinAssetBaseUrl/${genre.cover}",
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF343434).withOpacity(0.4),
                    const Color(0xFF343434).withOpacity(0.7),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
