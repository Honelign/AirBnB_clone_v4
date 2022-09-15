import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/screens/genre/genre.dart';
import 'package:kin_music_player_app/screens/home/components/favorite.dart';
import 'package:kin_music_player_app/screens/home/components/home_search_screen.dart';
import 'package:kin_music_player_app/screens/login_signup/verify_email.dart';
import 'package:kin_music_player_app/services/provider/login_provider.dart';
import 'package:kin_music_player_app/services/provider/recently_played_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../screens/album/album.dart';
import '../../services/provider/cached_favorite_music_provider.dart';
import '../../size_config.dart';
import '../../screens/artist/artist.dart';

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
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 2,
          actions: [
            Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(8)),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeSearchScreen.routeName);
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(5),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: 'Songs',
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
