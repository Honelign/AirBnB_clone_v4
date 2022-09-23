import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_detail.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';

import '../services/network/model/artist.dart';
import '../size_config.dart';

class ArtistCardSearch extends StatefulWidget {
  final int index;
  final ArtitstSearch artist;
  const ArtistCardSearch({Key? key, required this.artist, required this.index})
      : super(key: key);

  @override
  State<ArtistCardSearch> createState() => _ArtistCardSearchState();
}

class _ArtistCardSearchState extends State<ArtistCardSearch> {
  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<ArtistProvider>(context, listen: false);
    // provider.getArtistForSearch(widget.artist.id);
    // Artist artisttouched= provider.artist;

    return GestureDetector(
      onTap: () async {
        final provider = Provider.of<ArtistProvider>(context, listen: false);
        await provider.getArtistForSearch(widget.artist.id);
        Artist artisttouched = provider.artist;

        // await Future.delayed(Duration(microseconds: 500));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ArtistDetail(
        //               //artist: artisttouched,
        //               artist_id: '',
        //               artist: widget.artist,
        //             )));
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
                    imageUrl: '$kinAssetBaseUrl/${widget.artist.artistCover}',
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
                    widget.artist.artistName,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  Text(
                    widget.artist.artistTitle,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
