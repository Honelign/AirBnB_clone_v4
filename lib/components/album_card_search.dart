import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_detail.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/album_for_search.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';

import '../services/network/model/artist.dart';
import '../size_config.dart';

class AlbumCardSearch extends StatefulWidget {
  final int index;
  final AlbumSearch album;
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
        final provider = Provider.of<AlbumProvider>(context, listen: false);
        await provider.getAlbumForsearch(widget.album.id);
        Album albumtouched = provider.searchalbum;

        // await Future.delayed(Duration(microseconds: 500));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => AlbumBody(album: albumtouched),
        //   ),
        // );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: 70,
          width: 300,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 70,
                  child: CachedNetworkImage(
                    imageUrl: '$kinAssetBaseUrl/${widget.album.albumCover}',
                    fit: BoxFit.cover,
                    width: getProportionateScreenWidth(100),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.album.albumTitle,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  // Text(widget.artist.artistTitle,style: TextStyle(color: Colors.white,),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
