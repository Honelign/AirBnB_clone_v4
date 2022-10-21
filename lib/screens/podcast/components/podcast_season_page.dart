import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/episode_card.dart';
import 'package:kin_music_player_app/services/network/model/podcast/podcast_episode.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

class PodcastSeasonPage extends StatelessWidget {
  final String id;
  final String title;

  const PodcastSeasonPage({Key? key, required this.id, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PodcastProvider podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF052C54),
        title: Text(title),
        elevation: 0,
      ),
      body: Container(
        decoration: linearGradientDecoration,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<List<PodcastEpisode>>(
          future: podcastProvider.getPodcastEpisodes(
            pageSize: 1,
            seasonId: int.parse(id),
          ),
          builder: (context, snapshot) {
            // loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: KinProgressIndicator(),
              );
            }

            // loaded data
            else if (snapshot.hasData && !snapshot.hasError) {
              return ListView.builder(
                itemCount: podcastProvider.podcastEpisodes.length,
                itemBuilder: (context, index) {
                  return EpisodeCard(
                    podcastEpisode: snapshot.data![index],
                    index: index,
                    podcasts: snapshot.data!,
                  );
                },
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
