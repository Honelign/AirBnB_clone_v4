import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/artist_card_search.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/search/youtube_search_card.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:provider/provider.dart';

class ArtistSearchResult extends StatelessWidget {
  final List searchedMusicsList;
  final List searchedArtistList;
  const ArtistSearchResult(
      {Key? key,
      required this.searchedMusicsList,
      required this.searchedArtistList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context);
    return Expanded(
      child: provider.isLoading == true
          ? KinProgressIndicator()
          : 1 == 0
              ? provider.searchedMusics.isEmpty
                  ? const Center(
                      child: Text(
                      'No data',
                      style: TextStyle(color: kGrey),
                    ))
                  : ListView.builder(
                      itemCount: provider.searchedMusics.length,
                      itemBuilder: (context, index) {
                        // return MusicListCard(
                        //   music: provider.searchedMusics[index],
                        //   musics: searchedMusicsList,
                        //   musicIndex: index,
                        // );
                        return YoutubeSearchCard(
                          result: searchedMusicsList[index],
                        );
                      },
                    )
              : ListView.builder(
                  itemCount: searchedArtistList.length,
                  itemBuilder: ((context, index) {
                    return ArtistCardSearch(
                      artist: searchedArtistList[index],
                      index: index,
                    );
                  }),
                ),
    );
  }
}
