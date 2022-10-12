import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import 'episodes.dart';

class EpisodesList extends StatelessWidget {
  final PodCast podCast;

  const EpisodesList({Key? key, required this.podCast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  '$kinAssetsBaseUrlOld/${podCast.cover}'),
              fit: BoxFit.cover)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: podCast.episodes.length,
                    itemBuilder: (context, index) {
                      return Episodes(
                          episode: podCast.episodes[index],
                          episodeIndex: index,
                          podCast: podCast,
                          episodes: podCast.episodes);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
