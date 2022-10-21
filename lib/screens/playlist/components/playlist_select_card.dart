import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/multi_select_provider.dart';

import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistSelectCard extends StatefulWidget {
  PlaylistSelectCard({
    Key? key,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.musics,
    required this.music,
    required this.musicIndex,
    required this.isMusicSelected,
  }) : super(key: key);

  final double height, aspectRatio;
  final Music? music;
  final int musicIndex;
  final List<Music> musics;
  bool? isForPlaylist;
  int? playlistId;
  final bool isMusicSelected;

  @override
  State<PlaylistSelectCard> createState() => _PlaylistSelectCardState();
}

class _PlaylistSelectCardState extends State<PlaylistSelectCard> {
  late MultiSelectProvider multiSelectProvider;

  @override
  void initState() {
    multiSelectProvider =
        Provider.of<MultiSelectProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(widget.height - 8),
      width: getProportionateScreenWidth(75),
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(8),
        vertical: getProportionateScreenHeight(8),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: widget.isMusicSelected == true
            ? Colors.green.withOpacity(0.1)
            : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Select Icon
          SizedBox(
            height: getProportionateScreenHeight(widget.height),
            width: 25,
            child: Center(
              child: Container(
                width: 25,
                height: 25,
                decoration:
                    // ignore: unrelated_type_equality_checks
                    widget.isMusicSelected == false
                        ? BoxDecoration(
                            border: Border.all(
                              color: kSecondaryColor,
                              width: 2.0,
                            ),
                            shape: BoxShape.circle,
                          )
                        : BoxDecoration(
                            color: Colors.green.withOpacity(0.55),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green.withOpacity(0.55),
                              width: 2.0,
                            ),
                          ),
              ),
            ),
          ),

          const SizedBox(
            width: 24,
          ),

          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1.02,
              child: Container(
                color: kSecondaryColor.withOpacity(0.1),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '$kinAssetBaseUrl/${widget.music!.cover}',
                ),
              ),
            ),
          ),

          // spacer
          SizedBox(
            width: getProportionateScreenWidth(10),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.music!.title,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.music!.artist.isNotEmpty
                            ? widget.music!.artist
                            : 'kin artist',
                        style: const TextStyle(color: kGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
