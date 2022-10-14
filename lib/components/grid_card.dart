import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

import 'package:kin_music_player_app/size_config.dart';

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
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: getProportionateScreenWidth(120),
      child: InkWell(
        onTap: () async {
          List<Music> musics = [];

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumBody(
                album: album,
                albumMusicsFromCard: musics,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 107,
              height: 105,
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
          ],
        ),
      ),
    );
  }
}
