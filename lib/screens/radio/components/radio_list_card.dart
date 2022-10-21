import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

class RadioCardList extends StatelessWidget {
  final RadioStation station;
  final int index;
  const RadioCardList({Key? key, required this.station, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    RadioProvider radioProvider = Provider.of<RadioProvider>(context);
    PodcastPlayer podcastProvider = Provider.of<PodcastPlayer>(context);
    MusicPlayer musicProvider = Provider.of<MusicPlayer>(context);
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return InkWell(
      onTap: () {
        if (checkConnection(status)) {
          podcastProvider.player.stop();
          musicProvider.player.stop();

          musicProvider.setMusicStopped(true);
          podcastProvider.setEpisodeStopped(true);

          musicProvider.listenMusicStreaming();
          podcastProvider.listenPodcastStreaming();
          radioProvider.handlePlayButton(index);
          radioProvider.setPlayer(
              radioProvider.player, musicProvider, podcastProvider);
        } else {
          kShowToast();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 54,
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kSecondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Section
            Row(
              children: [
                // Image
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        station.coverImage,
                      ),
                    ),
                  ),
                ),

                // Spacer
                const SizedBox(
                  width: 8,
                ),

                // Title
                Text(
                  station.stationName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),

            // Right Section
            Row(
              children: const [
                Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
