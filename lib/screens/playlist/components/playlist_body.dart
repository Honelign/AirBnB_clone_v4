import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/music_list.dart';
import 'package:kin_music_player_app/components/section_title.dart';

import '../../../size_config.dart';

class PlayListBody extends StatelessWidget {
  final String? sectionTitle;
  final bool? hasSeeMore;

  const PlayListBody(
      {Key? key, this.sectionTitle = '', this.hasSeeMore = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMusicList(context),
        ],
      ),
    );
  }

  Widget _buildMusicList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: hasSeeMore!
              ? SectionTitle(title: sectionTitle!, press: () {})
              : Container(),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
      ],
    );
  }
}
