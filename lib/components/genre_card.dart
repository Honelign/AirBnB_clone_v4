import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/genre/components/genre_detail.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';

import '../constants.dart';
import '../size_config.dart';

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
    return ClipRRect(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                CachedNetworkImageProvider("$kinAssetBaseUrl/${genre.cover}"),
            fit: BoxFit.cover,
          ),
        ),
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GenreDetail(
                  genre: genre,
                ),
              ),
            );
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 2.0,
                  child: ClipRRect(
                      child: CachedNetworkImage(
                    imageUrl: "$kinAssetBaseUrl/${genre.cover}",
                    fit: BoxFit.cover,
                  )),
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                Text(
                  genre.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                Text(
                  '${genre.musics.length} tracks',
                  style: TextStyle(color: Colors.white.withOpacity(0.75)),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
