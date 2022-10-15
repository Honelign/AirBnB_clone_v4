import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kin_music_player_app/components/search/search_bar.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/album.dart';
import 'package:kin_music_player_app/screens/artist/artist.dart';
import 'package:kin_music_player_app/screens/genre/genre.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';

import '../../size_config.dart';
import 'components/songs.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // final provider = Provider.of<CachedFavoriteProvider>(context);
    //  provider.cacheFavorite( context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CustomSearchBar(),
          ),
          toolbarHeight: 60,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF052c54),
          elevation: 0,
          bottom: TabBar(
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
            tabs: const [
              Tab(
                text: 'Explore',
              ),
              Tab(
                text: 'Albums',
              ),
              Tab(
                text: 'Genres',
              ),
              Tab(
                text: 'Artists',
              ),
            ],
            indicatorColor: kSecondaryColor,
          ),
        ),
        body: const TabBarView(
          children: [
            Songs(),
            Albums(),
            Genres(),
            Artists(),
          ],
        ),
      ),
    );
  }
}
