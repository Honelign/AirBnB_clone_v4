import 'package:flutter/material.dart';

import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/library/favorite/components/favorite_list.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:provider/provider.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);
  static String routeName = 'favorite';

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    Provider.of<FavoriteMusicProvider>(context, listen: false).getFavMusic();

    Provider.of<CachedFavoriteProvider>(context, listen: false).getFavids();
  }

  @override
  Widget build(BuildContext context) {
    var centerSize = MediaQuery.of(context).size.height * 0.3;
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return checkConnection(status) == false
        ? RefreshIndicator(
            onRefresh: () async {
              setState(() {});
            },
            backgroundColor: refreshIndicatorBackgroundColor,
            color: refreshIndicatorForegroundColor,
            child: const NoConnectionDisplay(),
          )
        : Consumer<FavoriteMusicProvider>(
            builder: (context, provider, _) {
              return Scaffold(
                backgroundColor: kPrimaryColor,
                body: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  color: refreshIndicatorForegroundColor,
                  backgroundColor: refreshIndicatorBackgroundColor,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF052C54),
                          const Color(0xFFD9D9D9).withOpacity(0.7)
                        ],
                      )),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          /* const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 180),
                            child: Text(
                              "Your Favorites",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ), */
                          provider.isLoading == true
                              ? Padding(
                                  padding: EdgeInsets.only(top: centerSize),
                                  child: KinProgressIndicator(),
                                )
                              : provider.favoriteMusics == null ||
                                      provider.favoriteMusics.isEmpty
                                  ? Padding(
                                      padding: EdgeInsets.only(top: centerSize),
                                      child: Column(
                                        children: const [
                                          Text(
                                            "No Favorites yet",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Add your musics to access them here",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: ListView.builder(
                                        itemCount:
                                            provider.favoriteMusics.isNotEmpty
                                                ? provider.favoriteMusics.length
                                                : 0,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return FavoriteList(
                                            id: provider
                                                .favoriteMusics[index].music.id
                                                .toString(),
                                            music: provider
                                                .favoriteMusics[index].music,
                                            musicIndex: index,
                                            favoriteMusics:
                                                provider.favoriteMusics,
                                          );
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
