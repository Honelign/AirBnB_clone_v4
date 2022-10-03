import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/dashboard/components/album_graph_info.dart';
import 'package:kin_music_player_app/screens/dashboard/components/artist_graph_info.dart';
import 'package:kin_music_player_app/screens/dashboard/components/track_graph_info.dart';
import 'package:kin_music_player_app/services/provider/analytics_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class ArtistGraphCard extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final String cardType;
  const ArtistGraphCard(
      {Key? key,
      required this.id,
      required this.image,
      required this.name,
      required this.cardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (cardType == "Tracks") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TrackGraphPage(
                musicTitle: name,
                musicCover: image,
                trackId: id,
              ),
            ),
          );
        } else if (cardType == "Artists") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArtistGraphPage(
                artistId: id,
                artistName: name,
                artistCover: image,
              ),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AlbumGraphPage(
                albumId: id,
                albumTitle: name,
                albumCover: image,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(8),
        ),
        width: double.infinity,
        height: getProportionateScreenHeight(80),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: CachedNetworkImageProvider("$kinAssetBaseUrl/$image"),
                ),
              ),
              width: getProportionateScreenWidth(50),
            ),

            SizedBox(
              width: getProportionateScreenWidth(12),
            ),

            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
