import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class PodcastCard extends StatelessWidget {
  const PodcastCard({
    Key? key,
    this.width = 125,
    this.aspectRatio = 1.02,
    required this.podcast,
    required this.podcasts,
  }) : super(key: key);

  final double width, aspectRatio;
  final PodCast podcast;
  final List<PodCast> podcasts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Detail(
                      podCast: podcast,
                    )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.3,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: '$kinAssetsBaseUrlOld/${podcast.cover}',
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenHeight(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${podcast.narrator}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: kSecondaryColor,
                            fontSize: getProportionateScreenHeight(18)),
                      ),
                    ),
                    PopupMenuButton(
                      initialValue: 0,
                      child: const Icon(
                        Icons.more_vert,
                        color: kGrey,
                      ),
                      onSelected: (value) {},
                      itemBuilder: (context) {
                        return kPodcastPopupMenuItem;
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
                child: Text(
                  '${podcast.title}',
                  // overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(14)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${podcast.episodes.length} episodes',
                style: const TextStyle(color: kGrey),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
