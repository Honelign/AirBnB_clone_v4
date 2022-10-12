import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/network/model/podcast_old/podcastEpisode.dart';

mixin BaseMixins {
  dynamic responsive(BuildContext context, {isPhone, isSmallPhone, isTablet}) {
    var width = MediaQuery.of(context).size.width;
    if (width > 500) {
      return isTablet;
    } else if (width < 370) {
      return isSmallPhone;
    } else {
      return isPhone;
    }
  }

  List<Music> shuffle(List<Music> list) {
    var random = Random();
    int length = list.length;
    while (length > 1) {
      int pos = random.nextInt(length);
      length -= 1;
      var tmp = list[length];
      list[length] = list[pos];
      list[pos] = tmp;
    }
    return list;
  }

  List<PodCastEpisode?> shufflePodcast(List<PodCastEpisode?> list) {
    var random = Random();
    int length = list.length;
    while (length > 1) {
      int pos = random.nextInt(length);
      length -= 1;
      var tmp = list[length];
      list[length] = list[pos];
      list[pos] = tmp;
    }
    return list;
  }
}
