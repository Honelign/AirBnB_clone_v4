import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_detail_page.dart';

class PodcastCard extends StatelessWidget {
  int id;
  String url;
  String title;
  String host;
  String hostId;
  int numberOfSeasons;
  int numberOfEpisodes;
  String description;
  PodcastCard({
    Key? key,
    required this.id,
    required this.url,
    required this.host,
    required this.title,
    required this.hostId,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastDetailPage(
              podcastId: id.toString(),
              podcastName: title,
              cover: "$kinAssetBaseUrl-dev/" + url,
              host: host,
              hostId: hostId,
              numberOfEpisodes: numberOfEpisodes,
              numberOfSeasons: numberOfSeasons,
              description: description,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CachedNetworkImage(
            imageUrl: "$kinAssetBaseUrl-dev/" + url,
            imageBuilder: (context, img) {
              return Container(
                margin: const EdgeInsets.only(right: 28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: img,
                  ),
                ),
                width: 107,
                height: 105,
              );
            },
          ),

          //
          Container(
            constraints: const BoxConstraints(maxWidth: 100),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Container(
            constraints: BoxConstraints(maxWidth: 100),
            child: Text(
              host,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w300,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
