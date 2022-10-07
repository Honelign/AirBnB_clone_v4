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
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: provider.isLoading == true
                          ? const Center(
                              child: KinProgressIndicator(),
                            )
                          : provider.favoriteMusics == null ||
                                  provider.favoriteMusics.isEmpty
                              ? const Center(
                                  child: Text(
                                    "No Favorites yet",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
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
                                        favoriteMusics: provider.favoriteMusics,
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
