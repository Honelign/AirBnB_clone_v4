import 'package:flutter/material.dart';
import 'package:kin_music_player_app/screens/home/components/favorite_list.dart';
import 'package:kin_music_player_app/services/provider/cached_favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

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
  
  Provider.of<CachedFavoriteProvider>(context,listen: false).getFavids();
 
     
  
  }

  @override
  Widget build(BuildContext context) {
     
    return Consumer<FavoriteMusicProvider>(
    
      
      builder: (context, provider, _)
         {
        return  Scaffold(
          backgroundColor: kPrimaryColor,
          body: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: getProportionateScreenWidth(15)),
                  (provider.isLoading)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : provider.favoriteMusics == null ||
                              provider.favoriteMusics.length < 1
                          ? const Center(
                              child: Text(
                              'No Music Added To Favorite',
                              style: TextStyle(color: Colors.white),
                            ))
                          : ListView.builder(
                              itemCount: provider.favoriteMusics.length > 0
                                  ? provider.favoriteMusics[0].music.length
                                  : 0,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                               
                                return FavoriteList(
                                    id: provider.favoriteMusics[0].music[index].id.toString(),
                                    music: provider.favoriteMusics[0].music[index],
                                musicIndex: index,
                                favoriteMusics: provider.favoriteMusics[0].music);
            
                              })
                ],
              ),
          ),
        );
       
      },
    );
  }
}
