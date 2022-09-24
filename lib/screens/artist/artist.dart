import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/artist_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';
import 'package:provider/provider.dart';

import '../../size_config.dart';

class Artists extends StatefulWidget {
  const Artists({Key? key}) : super(key: key);

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArtistProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.getArtist(),
      builder: (context, AsyncSnapshot<List<Artist>> snapshot) {
        if (snapshot.hasData) {
          List<Artist> artists = snapshot.data!;
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return GridView.builder(
            itemCount: artists.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: getProportionateScreenWidth(25),
              mainAxisSpacing: getProportionateScreenWidth(25),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenHeight(25),
              vertical: getProportionateScreenHeight(25),
            ),
            itemBuilder: (context, index) {
              return ArtistCard(artist: artists[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong!',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
        return const Center(
          child: KinProgressIndicator(),
        );
      },
    );
  }
}
