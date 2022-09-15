import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/screens/genre/components/genre_app_bar.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';

import '../../../size_config.dart';

class GenreDetail extends StatelessWidget {
  final Genre genre;
  const GenreDetail({Key? key, required this.genre}) : super(key: key);
  static String routName = '/genreDetail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[GenreAppBar(genre: genre)];
            },
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          '$kinAssetBaseUrl/${genre.cover}'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenWidth(20)),
                      ListView.builder(
                          itemCount: genre.musics.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MusicListCard(
                              music: genre.musics[index],
                              musics: genre.musics,
                              musicIndex: index,
                            );
                          })
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
