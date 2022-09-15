import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/section_title.dart';

import '../size_config.dart';

class MusicList extends StatelessWidget {
  final String? sectionTitle;
  final bool? hasSeeMore;

  const MusicList({Key? key, this.sectionTitle = '', this.hasSeeMore = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
