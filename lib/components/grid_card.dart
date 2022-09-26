import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/network/model/music.dart';
import '../services/provider/music_provider.dart';
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
        onTap: ()async {
        
          List<Music> musics=[];
         
//  await Provider.of<MusicProvider>(context, listen: false)
//         .albumMusicsGetter(album.id);
//         musics =
//         Provider.of<MusicProvider>(context, listen: false).albumMusics;
//       //  print('@@@ ${albumMusicss}');
  
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumBody(
                album: album,
                albumMusicsfromcard: musics,
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
                  imageUrl: '${album.cover}',
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
              '',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
