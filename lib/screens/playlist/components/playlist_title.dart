import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_body.dart';

import 'package:kin_music_player_app/services/network/model/playlist_info.dart';

class PlaylistTitleDisplay extends StatelessWidget {
  PlaylistInfo playlistInfo;
  PlaylistTitleDisplay({Key? key, required this.playlistInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: kGrey.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          // icon
          Image.asset(
            "assets/icons/Playlist Icon.png",
            width: 32,
            height: 32,
          ),

          // spacer
          const SizedBox(
            width: 12,
          ),

          // title
          Text(
            playlistInfo.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
