import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class EpisodeCard extends StatefulWidget {
  final String cover;
  final String title;
  final String id;

  const EpisodeCard({
    Key? key,
    required this.cover,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("HEREEEE");
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 18, 12, 0),
        width: MediaQuery.of(context).size.width - 24,
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Image
                CachedNetworkImage(
                  imageUrl: "$kinAssetBaseUrl-dev/" + widget.cover,
                  imageBuilder: (context, img) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: img,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),

                const SizedBox(
                  width: 16,
                ),

                // Title
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Text(
                      "Episode :  " + widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),

                    // spacer
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert_rounded,
                color: kGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
