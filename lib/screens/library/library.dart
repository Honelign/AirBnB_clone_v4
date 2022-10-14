import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../size_config.dart';
import '../playlist/playlist.dart';
import 'Offline/offline.dart';
import 'Purchased/purchased.dart';
import 'favorite/favorite.dart';

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
          backgroundColor: Color(0xFF052c54),
          elevation: 0,
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
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.white,
              ],
            )),
            child: const TabBarView(children: [
              PlaylistsScreen(),
              Favorite(),
              Offline(),
              Purchased(),
            ])),
      ),
    );
  }
}
