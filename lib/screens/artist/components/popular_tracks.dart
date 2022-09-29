import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../services/provider/music_provider.dart';
import '../../../size_config.dart';

class PopularTracks extends StatefulWidget {
  static String routeName = 'popularTracks';
  final Artist artist;
  final String album_id;

  const PopularTracks({
    Key? key,
    required this.artist,
    required this.album_id,
  }) : super(key: key);

  @override
  State<PopularTracks> createState() => _PopularTracksState();
}

class _PopularTracksState extends State<PopularTracks> {
  @override
  void initState() {
    super.initState();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    musicProvider.getAlbumMusic(widget.album_id);
  }

  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    '$kinAssetBaseUrl/${musicProvider.music.cover}',
                  ),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
              color: kPrimaryColor.withOpacity(0.5),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildHeader(),
                        SizedBox(
                          height: getProportionateScreenHeight(15),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5, //artist.musics.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return MusicListCard(
                                music:
                                    musicProvider.music, //artist.musics[index],
                                musics: [], //artist.musics,
                                musicIndex: index,
                              );
                            })
                      ],
                    ),
                  ),
                  BackButton(
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final musicProvider = Provider.of<MusicProvider>(context);
    return Container(
        height: getProportionateScreenWidth(225),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(
                    '$kinAssetBaseUrl/${musicProvider.music.cover}'),
                fit: BoxFit.cover)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(50),
                  ),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      '$kinAssetBaseUrl/${musicProvider.music.cover}',
                    ),
                    maxRadius: getProportionateScreenHeight(60),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(15),
                  ),
                  Text(
                    musicProvider.music.artist,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: getProportionateScreenHeight(20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "5",
                        //'${artist.musics.length} tracks',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
