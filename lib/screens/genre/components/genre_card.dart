import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/genre/components/genre_detail.dart';
import 'package:kin_music_player_app/services/network/model/music/genre.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class GenreCard extends StatelessWidget {
  const GenreCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.genre,
  }) : super(key: key);

  final double width, aspectRatio;
  final Genre genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: getProportionateScreenWidth(120),
      child: InkWell(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GenreDetail(
                genre: genre,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 107,
              height: 103,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(-5, 5),
                    spreadRadius: -3,
                    blurRadius: 5,
                    color: Color.fromRGBO(0, 0, 0, 0.76),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return Image.asset("assets/images/logo.png");
                  },
                  fit: BoxFit.cover,
                  imageUrl: '$kinAssetBaseUrl/${genre.cover}',
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              genre.title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
