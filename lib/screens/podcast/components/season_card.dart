import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_season_page.dart';

class SeasonCard extends StatelessWidget {
  String cover;
  String title;
  String id;
  int numberOfEpisodes;

  SeasonCard({
    Key? key,
    required this.cover,
    required this.title,
    required this.id,
    required this.numberOfEpisodes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastSeasonPage(
              id: id,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 24, 12, 0),
        width: MediaQuery.of(context).size.width - 24,
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(cover),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                // Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      "Season " + title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),

                    // spacer
                    const SizedBox(
                      height: 4,
                    ),

                    // number of episodes
                    Text(
                      numberOfEpisodes.toString() + " episodes",
                      style: const TextStyle(
                        color: kGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: kGrey,
                ))
          ],
        ),
      ),
    );
  }
}
