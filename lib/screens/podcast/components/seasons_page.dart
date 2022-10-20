import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/season_card.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

class SeasonsPage extends StatelessWidget {
  final String id;
  const SeasonsPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PodcastProvider podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        decoration: linearGradientDecoration,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: podcastProvider.getPodcastSeasons(
            podcastId: int.parse(id),
            pageSize: 1,
          ),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: KinProgressIndicator(),
              );
            }

            // loaded
            else if (snapshot.hasData && !snapshot.hasError) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return SeasonCard(
                      id: podcastProvider.podcastSeason[index].id.toString(),
                      cover: podcastProvider.podcastSeason[index].cover,
                      title: podcastProvider.podcastSeason[index].seasonNumber
                          .toString(),
                      numberOfEpisodes:
                          podcastProvider.podcastSeason[index].numberOfEpisodes,
                    );
                  },
                  itemCount: podcastProvider.podcastSeason.length,
                ),
              );
            }

            // error
            else {
              return OnSnapshotError(
                error: snapshot.error.toString(),
              );
            }
          },
        ),
      ),
    );
  }
}
