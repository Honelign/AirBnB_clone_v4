import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/component/podcast_detail.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_detail_page.dart';

class PodcastCard extends StatelessWidget {
  String url;
  String title;
  String host;
  PodcastCard(
      {Key? key, required this.url, required this.host, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastDetailPage(
              podcastId: "1",
              podcastName: title,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Container(
            margin: const EdgeInsets.only(right: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: AssetImage(url),
              ),
            ),
            width: 130,
            height: 120,
          ),

          //
          Container(
            constraints: BoxConstraints(maxWidth: 100),
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
