import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
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
      decoration: BoxDecoration(
        color: kGrey.withOpacity(0.075),
        borderRadius: BorderRadius.circular(10),
      ),
      width: getProportionateScreenWidth(width),
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
            AspectRatio(
              aspectRatio: 1.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
            SizedBox(
              height: getProportionateScreenHeight(2),
            ),
            const Text(
              '',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
