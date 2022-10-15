import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          backgroundColor: const Color(0xFF052c54),
          systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: kSecondaryColor,
            statusBarColor: kSecondaryColor,
          ),
          elevation: 0,
          bottom: TabBar(
            indicatorPadding: EdgeInsets.all(0),
            indicatorWeight: 3.0,
            labelPadding: EdgeInsets.all(0),
            indicatorSize: TabBarIndicatorSize.label,
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
