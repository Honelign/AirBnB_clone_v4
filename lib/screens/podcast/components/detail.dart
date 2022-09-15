import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/podcast/components/podcast_detail.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';

import '../../../constants.dart';
import 'episodes_list.dart';

class Detail extends StatelessWidget {
  final PodCast podCast;

  const Detail({
    Key? key,
    required this.podCast,
  }) : super(key: key);
  static String routeName = 'detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool isInnerBoxScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  backgroundColor: kPrimaryColor,
                  elevation: 2,
                  title: Text(podCast.title),
                  bottom: const PreferredSize(
                    preferredSize: Size(double.infinity, 75),
                    child: TabBar(
                      labelColor: Colors.white,
                      indicatorColor: kSecondaryColor,
                      unselectedLabelColor: kGrey,
                      tabs: [
                        Tab(
                          text: 'Detail',
                        ),
                        Tab(text: 'Episodes'),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: '$kinAssetsBaseUrlOld/${podCast.cover}',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                const Color(0xFF343434).withOpacity(0.4),
                                const Color(0xFF343434).withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: TabBarView(children: [
              PodcastDetail(podCast: podCast),
              EpisodesList(podCast: podCast)
            ])),
      ),
    );
  }
}
