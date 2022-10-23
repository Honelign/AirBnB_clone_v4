import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../playlist/playlist.dart';
import 'Offline/offline.dart';
import 'Purchased/purchased.dart';
import 'favorite/favorite.dart';

class MyLibrary extends StatefulWidget {
  final int initialIndex;
  final bool showToast;
  const MyLibrary(
      {Key? key, required this.initialIndex, required this.showToast})
      : super(key: key);

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    if (widget.showToast == true) {
      kShowToast(message: "No Connection. Listen Offline");
    }
    return DefaultTabController(
      length: 4,
      initialIndex: widget.initialIndex ?? 0,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF052c54),
          elevation: 0,
          title: TabBar(
            labelColor: kSecondaryColor,
            unselectedLabelColor: Colors.white,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            indicatorPadding: const EdgeInsets.only(
              top: 15,
              bottom: 19,
              left: 10,
              right: 10,
            ),
            indicatorWeight: 5.0,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            //padding: EdgeInsets.symmetric(vertical: 20),
            labelPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            //  indicatorSize: TabBarIndicatorSize.label,
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
          child: const TabBarView(
            children: [
              PlaylistsScreen(),
              Favorite(),
              Offline(),
              Purchased(),
            ],
          ),
        ),
      ),
    );
  }
}
