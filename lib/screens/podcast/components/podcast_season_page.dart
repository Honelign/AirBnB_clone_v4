import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/podcast/components/episode_card.dart';
import 'package:kin_music_player_app/services/provider/podcast_provider.dart';
import 'package:provider/provider.dart';

class PodcastSeasonPage extends StatelessWidget {
  String id;

  PodcastSeasonPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PodcastProvider podcastProvider =
        Provider.of<PodcastProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
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
                    cover: podcastProvider.podcastEpisodes[index].cover,
                    title: podcastProvider.podcastEpisodes[index].episodeTitle
                        .toString(),
                    id: podcastProvider.podcastEpisodes[index].id.toString(),
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
