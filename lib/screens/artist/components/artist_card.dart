import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_detail.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class ArtistCard extends StatelessWidget {
  const ArtistCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.artist,
  }) : super(key: key);

  final double width, aspectRatio;
  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistDetail(
              artist_id: artist.id.toString(),
              artist: artist,
            ),
          ),
        );
      },
      child: GridTile(
        child: AspectRatio(
          aspectRatio: 1.02,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: '$kinAssetBaseUrl/${artist.artist_profileImage}',
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: ClipRect(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(5),
              horizontal: getProportionateScreenWidth(5),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.artist_name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: getProportionateScreenHeight(5)),
                  Row(
                    children: [
                      Text(
                        "Albums ${artist.noOfAlbums}",
                        style: const TextStyle(
                          color: kGrey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                      SizedBox(width: getProportionateScreenWidth(8)),
                      Text(
                        "Tracks ${artist.noOfTracks}",
                        style: const TextStyle(
                          color: kGrey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.clip,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
