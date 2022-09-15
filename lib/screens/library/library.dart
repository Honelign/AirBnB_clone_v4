import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../album/album.dart';
import '../artist/artist.dart';
import '../genre/genre.dart';
import '../home/components/favorite.dart';
import '../home/components/home_search_screen.dart';
import '../home/components/songs.dart';
import '../playlist/playlist.dart';
import 'Offline/offline.dart';
import 'Purchased/purchased.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({Key? key}) : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,

          title: const TabBar(
            //  indicatorPadding: EdgeInsets.all(0),
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(5),
            indicatorSize: TabBarIndicatorSize.label,

            // padding: EdgeInsets.all(5),
            tabs: [
              Tab(
                text: 'Playlist',
              ),
              Tab(
                text: 'Favorite',
              ),
              Tab(
                text: 'Offline',
              ),
              Tab(
                text: 'Purchased',
              ),
            ],
            indicatorColor: kSecondaryColor,
          ),
        ),
        body: TabBarView(children: [
          PlayLists(),
          const Favorite(),
          const Offline(),
          const Purchased(),
        ]),
      ),
    );
  }
}
