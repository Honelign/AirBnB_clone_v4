import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/ad_banner.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_card.dart';
import 'package:kin_music_player_app/components/music_card_recently.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/components/section_titile_recently.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/screens/artist/components/artist_detail.dart';
import 'package:kin_music_player_app/screens/home/components/all_music_list.dart';
import 'package:kin_music_player_app/screens/home/components/genre_home_display.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/artist.dart';
import 'package:kin_music_player_app/services/network/model/music/genre.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/artist_provider.dart';

import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';

import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/recently_played_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    bool isReleased = false;
    super.build(context);
    ConnectivityStatus status =
        Provider.of<ConnectivityStatus>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      backgroundColor: refreshIndicatorBackgroundColor,
      color: refreshIndicatorForegroundColor,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: linearGradientDecoration,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spacer
              SizedBox(
                height: getProportionateScreenHeight(6),
              ),

              InkWell(
                onTap: () async {
                  Provider.of<MusicPlayer>(context, listen: false)
                      .player
                      .stop();

                  Provider.of<MusicPlayer>(context, listen: false)
                      .isProcessingPlay = false;
                },
                child: Container(
                  width: 60,
                  height: 30,
                  color: Colors.amber,
                ),
              ),

              // Recently Played
              _buildRecentlyPlayedMusics(context),

              // Spacer
              SizedBox(height: getProportionateScreenWidth(5)),

              // Ad Banner
              const AdBanner(),

              // Spacer
              checkConnection(status) == false && isReleased == true
                  ? Container(
                      child: const NoConnectionDisplay(),
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                    )
                  : Column(
                      children: [
                        SizedBox(height: getProportionateScreenWidth(10)),

                        // New Released Albums
                        _buildNewReleasedAlbums(context),

                        // Spacer
                        SizedBox(height: getProportionateScreenWidth(10)),

                        // Popular Music
                        _buildPopularMusics(context),

                        // Spacer
                        SizedBox(height: getProportionateScreenWidth(10)),

                        // Artists
                        _buildArtist(context),

                        // Spacer
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),

                        // New Music
                        _buildRecentMusics(context),

                        // Spacer
                        SizedBox(
                          height: getProportionateScreenHeight(10),
                        ),

                        // Genre
                        _buildGenres(context)
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewReleasedAlbums(BuildContext context) {
    final provider = Provider.of<AlbumProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Text('New Albums', style: headerTextStyle),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        SizedBox(
          height: getProportionateScreenHeight(145),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                future: provider.getAlbums(pageSize: 1),
                builder: (context, AsyncSnapshot<List<Album>> snapshot) {
                  if (!(snapshot.connectionState == ConnectionState.waiting)) {
                    if (snapshot.hasData) {
                      List<Album> albums = snapshot.data!;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (albums.length > 8 ? 8 : albums.length),
                        itemBuilder: (context, index) {
                          return SpecialOfferCard(
                              image: albums[index].cover,
                              genre: albums[index].title,
                              // numOfMusics: albums[index].musics.length,
                              press: () async {
                                List<Music> musics = [];

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AlbumBody(
                                      albumMusicsFromCard: musics,
                                      album: albums[index],
                                    ),
                                  ),
                                );
                              });
                        },
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            kConnectionErrorMessage,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      );
                    }
                  }
                  return Container(
                      margin:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
                      child: const Center(
                        child: KinProgressIndicator(),
                      ));
                },
              )),
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedMusics(BuildContext context) {
    final provider =
        Provider.of<RecentlyPlayedProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: const SectionTitleRecently(
            title: "Recently Played",
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        FutureBuilder(
          future: provider.getRecentlyPlayed(),
          builder: (context, AsyncSnapshot<List<Music>> snapshot) {
            provider.getRecentlyPlayed();
            if (!(snapshot.connectionState == ConnectionState.waiting)) {
              if (snapshot.hasData) {
                List<Music> musics = snapshot.data!;
                int length = 0;
                if (snapshot.data?.length == 1 || snapshot.data?.length == 2) {
                  length = 1;
                } else {
                  if (snapshot.data?.length == 3 ||
                      snapshot.data?.length == 4) {
                    length = 2;
                  }
                }
                // if no music
                if (musics.isEmpty) {
                  return const Center(
                    child: SizedBox(
                      height: 50.0,
                      child: Text(
                        "No Recently Played Music",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 80.0 * length.toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              childAspectRatio: 2.6,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5),
                      itemCount: snapshot.data?.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MusicCardRecently(
                            music: musics[index],
                            musicIndex: index,
                            musics: musics);
                      },
                    ),
                  ),
                );
              } else {
                kShowToast();
                return SizedBox(
                  width: double.infinity,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      kConnectionErrorMessage,
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                );
              }
            }
            return Container(
              margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
              child: const Center(
                child: KinProgressIndicator(),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _buildPopularMusics(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "Popular Musics",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllMusicList(),
                  ),
                );
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(10)),
        SizedBox(
          height: getProportionateScreenHeight(200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: provider.getPopularMusic(),
              builder: (context, AsyncSnapshot<List<Music>> snapshot) {
                if (!(snapshot.connectionState == ConnectionState.waiting)) {
                  if (snapshot.hasData) {
                    List<Music> musics = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data == null
                          ? 0
                          : (snapshot.data!.length > 5
                              ? 5
                              : snapshot.data!.length),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MusicCard(
                          music: musics[index],
                          musicIndex: index,
                          musics: musics,
                        );
                      },
                    );
                  } else {
                    kShowToast();
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          kConnectionErrorMessage,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ),
                    );
                  }
                }
                return Container(
                  margin: EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
                  child: const Center(
                    child: KinProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildArtist(BuildContext context) {
    final provider = Provider.of<ArtistProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Text('Artists', style: headerTextStyle),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        SizedBox(
          height: getProportionateScreenHeight(200),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<Artist>>(
                future: provider.getArtist(pageSize: 1),
                builder: (context, snapshot) {
                  if (!(snapshot.connectionState == ConnectionState.waiting)) {
                    if (snapshot.hasData) {
                      List<Artist> artists = snapshot.data!;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (artists.length > 8 ? 8 : artists.length),
                        itemBuilder: (context, index) {
                          return SpecialOfferCardartist(artist: artists[index]);
                        },
                      );
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            kConnectionErrorMessage,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      );
                    }
                  }
                  return Container(
                      margin:
                          EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
                      child: const Center(
                        child: KinProgressIndicator(),
                      ));
                },
              )),
        ),
      ],
    );
  }

  Widget _buildRecentMusics(BuildContext context) {
    final provider = Provider.of<MusicProvider>(context, listen: false);

    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "New Musics",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllMusicList(from: 1),
                  ),
                );
              }),
        ),
        SizedBox(
          height: getProportionateScreenHeight(20),
        ),
        SizedBox(
          height: getProportionateScreenHeight(200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
                future: provider.getNewMusics(),
                builder: (context, AsyncSnapshot<List<Music>> snapshot) {
                  if (!(snapshot.connectionState == ConnectionState.waiting)) {
                    if (snapshot.hasData) {
                      List<Music> musics = snapshot.data!;
                      return ListView.builder(
                          itemCount: snapshot.data == null
                              ? 0
                              : (snapshot.data!.length > 5
                                  ? 5
                                  : snapshot.data!.length),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MusicCard(
                              music: musics[index],
                              musics: musics,
                              musicIndex: index,
                            );
                          });
                    } else {
                      kShowToast();
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            kConnectionErrorMessage,
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        ),
                      );
                    }
                  }
                  return const Center(
                    child: KinProgressIndicator(),
                  );
                }),
          ),
        )
      ],
    );
  }

  Widget _buildGenres(BuildContext context) {
    final provider = Provider.of<GenreProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(22),
          ),
          child: SectionTitle(
              title: "Genres",
              press: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AllMusicList(),
                  ),
                );
              }),
        ),

        // Spacer
        SizedBox(height: getProportionateScreenHeight(20)),

        // Scroll Child
        SizedBox(
          height: getProportionateScreenHeight(160),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
              future: provider.getAllGenres(),
              builder: (context, AsyncSnapshot<List<Genre>> snapshot) {
                // loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Center(
                      child: KinProgressIndicator(),
                    ),
                  );
                }

                // data loaded
                else if (snapshot.hasData && !snapshot.hasError) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data == null
                          ? 0
                          : (snapshot.data!.length > 5
                              ? 5
                              : snapshot.data!.length),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return GenreHomeDisplay(genre: snapshot.data![index]);
                      });
                }

                // error
                else {
                  return OnSnapshotError(
                    error: snapshot.error.toString(),
                  );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.genre,
    required this.image,
    // required this.numOfMusics,
    required this.press,
  }) : super(key: key);

  final String genre, image;
  // final int numOfMusics;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: '$kinAssetBaseUrl/$image',

                //  width: double.infinity,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 115,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(-5, 5),
                          spreadRadius: -3,
                          blurRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 0.76),
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  );
                },
              ),
              Text(
                genre,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialOfferCardartist extends StatelessWidget {
  const SpecialOfferCardartist({
    Key? key,
    required this.artist,
    // required this.numOfMusics,
  }) : super(key: key);

  final Artist artist;
  // final int numOfMusics;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ArtistDetail(
              artist_id: artist.id.toString(),
              artist: artist,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
        child: SizedBox(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(100),
          child: Column(
            children: [
              CachedNetworkImage(
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-5, 5),
                            spreadRadius: -3,
                            blurRadius: 5,
                            color: Color.fromRGBO(0, 0, 0, 0.76),
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider)),
                  );
                },
                imageUrl: '$kinAssetBaseUrl/${artist.artist_profileImage}',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                artist.artist_name,
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
