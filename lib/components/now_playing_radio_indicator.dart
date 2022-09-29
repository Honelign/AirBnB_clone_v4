import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  double minPlayerHeight = 70;

  @override
  Widget build(BuildContext context) {
    final RadioProvider radioProvider =
        Provider.of<RadioProvider>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: radioProvider.player,
        builder: (context, isPlaying) {
          return SizedBox(
            height: minPlayerHeight,
            child: Stack(
              children: [
                _buildBlurBackground(radioProvider
                    .stations[radioProvider.currentIndex].coverImage),
                _buildDarkContainer(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade600),
                      boxShadow: const [
                        BoxShadow(
                          spreadRadius: 4,
                          color: Colors.black,
                          offset: Offset(2, 2),
                          blurRadius: 13,
                        )
                      ]),
                  height: 70,
                  // color: Colors.black,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(20),
                      getProportionateScreenHeight(10),
                      getProportionateScreenWidth(30),
                      getProportionateScreenHeight(10)),
                  child: Row(
                    children: [
                      _buildCover(radioProvider
                          .stations[radioProvider.currentIndex].coverImage),
                      SizedBox(
                        width: getProportionateScreenWidth(10),
                      ),
                      _buildTitleAndArtist(
                          radioProvider
                              .stations[radioProvider.currentIndex].stationName,
                          radioProvider
                              .stations[radioProvider.currentIndex].mhz),
                      _buildPlayPauseButton(
                        radioProvider,
                      ),
                    ],
                  ),
                ),
                //_buildCloseButton(radioProvider),
              ],
            ),
          );
        });
  }

  Widget _buildBlurBackground(musicCover) {
    return ClipRect(
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                musicCover,
              ),
              fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const SizedBox(
            height: 70,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDarkContainer() {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryColor.withOpacity(0.25),
            kPrimaryColor.withOpacity(0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(coverImage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 1.02,
        child: Container(
          color: kSecondaryColor.withOpacity(0.1),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: "$coverImage",
          ),
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

  Widget _buildPlayPauseButton(RadioProvider radioProvider) {
    return InkWell(
      onTap: () {
        radioProvider.player.stop();
        radioProvider.setIsPlaying(false);
        radioProvider.setMiniPlayerVisibility(false);

        setState(() {
          minPlayerHeight = 0;
        });
      },
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(1000)),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 15,
          child: SvgPicture.asset(
            'assets/icons/on-off-button.svg',
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

// Widget _buildCloseButton(provider) {
//   return Positioned(
//     top: -10,
//     right: -10,
//     child: IconButton(
//         onPressed: ()  {
//           provider.player.stop();
//           provider.player.dispose();
//           setState(() {
//             minPlayerHeight = 0;
//           });
//         },
//         icon: const Icon(
//           Icons.clear,
//           color: kGrey,
//           size: 20,
//         )),
//   );
// }

}
