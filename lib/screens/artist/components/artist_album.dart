import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import '../../../constants.dart';
import '../../../size_config.dart';

class ArtistAlbum extends StatelessWidget {
  static String routeName = 'artistAlbum';
  final List<Album> albums;
  final String artistCover;

  const ArtistAlbum({Key? key, required this.albums, required this.artistCover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text('Albums'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image:
                    CachedNetworkImageProvider('$kinAssetBaseUrl/$artistCover'),
                fit: BoxFit.cover),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: GridView.builder(
              itemCount: albums.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GridCard(album: albums[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: getProportionateScreenWidth(25),
                  mainAxisSpacing: 15),
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenHeight(25),
                  vertical: getProportionateScreenHeight(25)),
            ),
          ),
        ));
  }
}
