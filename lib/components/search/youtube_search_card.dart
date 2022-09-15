import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/video_player.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/youtube_search_result.dart';
import 'package:kin_music_player_app/size_config.dart';

class YoutubeSearchCard extends StatelessWidget {
  final YoutubeSearchResult result;
  const YoutubeSearchCard({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // play video
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CustomVideoPlayer(
              artistName: result.channel,
              songTitle: result.title,
              videoId: result.id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        child: Row(
          children: [
            // Image
            CachedNetworkImage(
              imageUrl: result.cover,
              imageBuilder: (context, imageProvider) => Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: getProportionateScreenWidth(12),
            ),

            // title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    result.title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                // channel
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    result.channel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
