import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/services/network/model/album_for_search.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:provider/provider.dart';

import '../screens/album/components/album_body.dart';
import '../services/network/model/music/music.dart';
import '../size_config.dart';

class AlbumCardSearch extends StatefulWidget {
  final int index;
  final Album album;
  const AlbumCardSearch({Key? key, required this.album, required this.index})
      : super(key: key);

  @override
  State<AlbumCardSearch> createState() => _AlbumCardSearchState();
}

class _AlbumCardSearchState extends State<AlbumCardSearch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // final provider = Provider.of<AlbumProvider>(context, listen: false);
        // await provider.getAlbumForSearch(widget.album.id);
        List<Music> musics = [];
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumBody(
                album: widget.album,
                albumMusicsFromCard: musics,
              ),
            ),
          );
        // await Future.delayed(Duration(microseconds: 500));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AlbumBody(album: albumtouched),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        child: SizedBox(
          height: 70,
          width: 130,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: CachedNetworkImage(
                    imageUrl: '$kinAssetBaseUrl/${widget.album.cover}',
                    fit: BoxFit.cover,
                    width: getProportionateScreenWidth(100),
                  ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
