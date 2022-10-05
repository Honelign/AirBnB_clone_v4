import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/genre/components/genre_detail.dart';
import 'package:kin_music_player_app/services/network/model/music/genre.dart';

class GenreHomeDisplay extends StatelessWidget {
  const GenreHomeDisplay({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.genre,
  }) : super(key: key);

  final double width, aspectRatio;
  final Genre genre;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GenreDetail(
              genre: genre,
            ),
          ),
        );
      },
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.sta,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  "$kinAssetBaseUrl/${genre.cover}",
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),

          // Spacer
          const SizedBox(
            height: 4,
          ),
          //
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
            child: Text(
              genre.title,
              style: const TextStyle(color: Colors.white, fontSize: 17),
            ),
          )
        ],
      ),
    );
  }
}
