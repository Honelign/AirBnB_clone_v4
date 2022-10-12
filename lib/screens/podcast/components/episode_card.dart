import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_season_page.dart';

class EpisodeCard extends StatelessWidget {
  String cover;
  String title;
  String id;

  EpisodeCard({
    Key? key,
    required this.cover,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 18, 12, 0),
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
                width: 50,
                height: 50,
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
                    "Episode :  " + title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),

                  // spacer
                  const SizedBox(
                    height: 4,
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
    );
  }
}
