import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/genre_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../services/provider/genre_provider.dart';
import '../../size_config.dart';

class Genres extends StatefulWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GenreProvider>(context, listen: false);

    super.build(context);
    return RefreshIndicator(
      color: kSecondaryColor,
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder(
        future: provider.getAllGenres(),
        builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
          if (provider.isLoading &&
              snapshot.connectionState == ConnectionState.waiting) {
            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: const Center(
                    child: KinProgressIndicator(),
                  ),
                )
              ],
            );
          } else if (provider.isLoading &&
              !(snapshot.connectionState == ConnectionState.active)) {
            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Center(
                    child: Text(
                      "No Internet",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            List<Genre> genres = snapshot.data!;

            return GridView.builder(
                itemCount: genres.length,
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenHeight(10),
                    vertical: getProportionateScreenHeight(25)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: getProportionateScreenWidth(15),
                    mainAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return GenreCard(genre: genres[index]);
                });
          } else if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            return ListView(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3),
                  child: Text(
                    "No Data",
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                )
              ],
            );
          }
          return ListView(
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: KinProgressIndicator(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}




/* import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/genre_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../services/provider/genre_provider.dart';
import '../../size_config.dart';

class Genres extends StatefulWidget {
  const Genres({Key? key}) : super(key: key);

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GenreProvider>(context, listen: false);

    super.build(context);
    return RefreshIndicator(
        color: kSecondaryColor,
        onRefresh: () async {
          setState(() {});
        },
        child: FutureBuilder(
            future: provider.getGenre(),
            builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
              if (provider.isLoading &&
                  snapshot.connectionState == ConnectionState.waiting) {
                return ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Center(
                        child: KinProgressIndicator(),
                      ),
                    )
                  ],
                );
              } else if (provider.isLoading &&
                  !(snapshot.connectionState == ConnectionState.active)) {
                return ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Center(
                        child: Text(
                          "No Internet",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    )
                  ],
                );
              } else if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<Genre> genres = snapshot.data!;

                return GridView.builder(
                    itemCount: genres.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(25),
                        vertical: getProportionateScreenHeight(25)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: getProportionateScreenWidth(15),
                        mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return GenreCard(genre: genres[index]);
                    });
              } else if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.active) {
                return ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.3),
                      child: Text(
                        "No Data",
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    )
                  ],
                );
              }
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(
                      child: KinProgressIndicator(),
                    ),
                  )
                ],
              );
              // }

              /*  getGenres('/music/genres'),
      builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading'));
        } else if (snapshot.data == null) {
          return const Center(child: Text("dataNotFound"));
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        } else if (snapshot.hasData) {
          List<Genre> genres = snapshot.data!;

          return GridView.builder(
              itemCount: genres.length,
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenHeight(25),
                  vertical: getProportionateScreenHeight(25)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: getProportionateScreenWidth(15),
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return GenreCard(genre: genres[index]);
              });
        }
        return Center(child: KinProgressIndicator());
      },
    ); */
            }));
  }
}
 */