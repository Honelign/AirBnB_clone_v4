import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/ad_banner.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_card.dart';
import 'package:kin_music_player_app/components/music_card_recently.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_titile_recently.dart';

import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/album/components/album_body.dart';
import 'package:kin_music_player_app/screens/payment/paypal/makepayment.dart';

import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/recently_played_provider.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'all_music_list.dart';

class Songs extends StatefulWidget {
  const Songs({Key? key}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Container(
        color: kPrimaryColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: getProportionateScreenHeight(15),
              ),
              const AdBanner(),
              _buildRecentlyPlayedMusics(context),
              SizedBox(height: getProportionateScreenWidth(20)),
              _buildNewReleasedAlbums(context),
              SizedBox(height: getProportionateScreenWidth(30)),
              _buildPopularMusics(context),
              SizedBox(height: getProportionateScreenWidth(20)),
              _buildRecentMusics(context),
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
              child: const Text(
                'New Albums',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SizedBox(
          height: getProportionateScreenHeight(120),
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
                      child: Center(
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
        SizedBox(height: getProportionateScreenHeight(20)),
        FutureBuilder(
          future: provider.getRecentlyPlayed(),
          builder: (context, AsyncSnapshot<List<Music>> snapshot) {
            provider.getRecentlyPlayed();
            if (!(snapshot.connectionState == ConnectionState.waiting)) {
              if (snapshot.hasData) {
                List<Music> musics = snapshot.data!;
                int? length;
                if (snapshot.data?.length == 1 || snapshot.data?.length == 2) {
                  length = 1;
                } else {
                  if (snapshot.data?.length == 3 ||
                      snapshot.data?.length == 4) {
                    length = 2;
                  } else if (snapshot.data?.length == 5 ||
                      snapshot.data?.length == 6) {
                    length = 3;
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
                  height: 66.0 * length!.toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 220,
                              childAspectRatio: 3.2,
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
                child: Center(
                  child: KinProgressIndicator(),
                ));
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
                    MaterialPageRoute(builder: (context) => AllMusicList()));
              }),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
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
                return Container(
                    margin:
                        EdgeInsets.only(left: SizeConfig.screenWidth * 0.46),
                    child: Center(
                      child: KinProgressIndicator(),
                    ));
              },
            ),
          ),
        )
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
        FutureBuilder(
            future: provider.getNewMusics(),
            builder: (context, AsyncSnapshot<List<Music>> snapshot) {
              if (!(snapshot.connectionState == ConnectionState.waiting)) {
                if (snapshot.hasData) {
                  List<Music> musics = snapshot.data!;
                  return ListView.builder(
                      itemCount: snapshot.data == null
                          ? 0
                          : (snapshot.data!.length > 8
                              ? 8
                              : snapshot.data!.length),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return MusicListCard(
                            music: musics[index],
                            musics: musics,
                            musicIndex: index);
                      });
                } else {
                  kShowToast();
                  return Text(
                    kConnectionErrorMessage,
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  );
                }
              }
              return Center(
                child: KinProgressIndicator(),
              );
            })
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: '$kinAssetBaseUrl/$image',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF343434).withOpacity(0.3),
                        const Color(0xFF343434).withOpacity(0.45),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$genre\n",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextSpan(text: "$numOfMusics Musics")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
