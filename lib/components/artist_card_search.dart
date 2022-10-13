import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/artist_for_search.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';

import '../screens/artist/components/artist_detail.dart';
import '../size_config.dart';

class ArtistCardSearch extends StatefulWidget {
  final int index;
  final Artist artist;
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
      onTap: ()  {
        final provider = Provider.of<ArtistProvider>(context, listen: false);
        //  await provider.getArtistForSearch(widget.artist.id);
        //  Artist artisttouched = provider.artist;
       Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistDetail(
              artist_id: widget.artist.id.toString(),
              artist: widget.artist,
            ),
          ),
        );
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
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
        child: Container(
         
          height: 100,
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  height: 100,
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: '$kinAssetBaseUrl/${widget.artist.artist_profileImage}',
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
