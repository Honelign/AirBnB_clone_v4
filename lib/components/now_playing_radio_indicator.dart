import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../size_config.dart';

class NowPlayingRadioIndicator extends StatefulWidget {
  const NowPlayingRadioIndicator({Key? key}) : super(key: key);

  @override
  State<NowPlayingRadioIndicator> createState() =>
      _NowPlayingRadioIndicatorState();
}

class _NowPlayingRadioIndicatorState extends State<NowPlayingRadioIndicator> {
  double minPlayerHeight = 65;

  @override
  Widget build(BuildContext context) {
    final RadioProvider radioProvider =
        Provider.of<RadioProvider>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: radioProvider.player,
        builder: (context, isPlaying) {
          return Container(
            color: kSecondaryColor,
            height: minPlayerHeight,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              height: 70,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                getProportionateScreenWidth(20),
                getProportionateScreenHeight(10),
                getProportionateScreenWidth(30),
                getProportionateScreenHeight(10),
              ),
              child: Row(
                children: [
                  _buildCover(
                    radioProvider
                        .stations[radioProvider.currentIndex].coverImage,
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(10),
                  ),
                  _buildTitleAndArtist(
                    radioProvider
                        .stations[radioProvider.currentIndex].stationName,
                    radioProvider.stations[radioProvider.currentIndex].mhz,
                  ),
                  _buildPlayPauseButton(),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildCover(coverImage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1.02,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: "$coverImage",
        ),
      ),
    );
  }

  Widget _buildTitleAndArtist(stationTitle, mhz) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stationTitle,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            mhz,
            style: const TextStyle(color: kGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseButton() {
    RadioProvider radioProvider = Provider.of<RadioProvider>(context);
    return InkWell(
      onTap: () {
        if (radioProvider.isPlaying) {
          radioProvider.player.play();
          radioProvider.setIsPlaying(false);
          radioProvider.setMiniPlayerVisibility(false);
        } else {
          radioProvider.player.stop();
          radioProvider.setIsPlaying(false);
          radioProvider.setMiniPlayerVisibility(false);

          setState(() {
            minPlayerHeight = 0;
          });
        }
      },
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        child: Icon(
          radioProvider.isPlaying == true
              ? Icons.pause
              : Icons.power_settings_new_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
