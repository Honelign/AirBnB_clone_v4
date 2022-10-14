import 'package:flutter/material.dart';
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
          toolbarHeight: 15,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 2,

          // actions: [
          //   Padding(
          //     padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
          //     child: IconButton(
          //       onPressed: () {
          //         Navigator.pushNamed(context, HomeSearchScreen.routeName);
          //       },
          //       icon: const Icon(
          //         Icons.search,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ],
          bottom: const TabBar(
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: 'Home',
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
