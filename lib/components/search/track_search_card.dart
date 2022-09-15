import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/track_for_search.dart';

class TrackSearchCard extends StatelessWidget {
  final TrackSearch tracksearch;
  const TrackSearchCard({Key? key, required this.tracksearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        imageUrl: tracksearch.albumId.albumCover,
      ),
      title: Text(tracksearch.trackName),
      subtitle: Text(tracksearch.artistId.artistName),
    );
  }
}
