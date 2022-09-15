import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';

import '../constants.dart';
import '../size_config.dart';

class GridCard extends StatelessWidget {
  const GridCard({
    Key? key,
    this.width = 140,
    required this.album,
  }) : super(key: key);

  final double width;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: kGrey.withOpacity(0.075),
        borderRadius: BorderRadius.circular(10),
      ),
      width: getProportionateScreenWidth(width),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumBody(
                album: album,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '$kinAssetBaseUrl/${album.cover}',
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              album.title,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: getProportionateScreenHeight(2),
            ),
            Text(
              album.artist,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
