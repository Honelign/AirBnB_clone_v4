import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_card_recently.dart';

import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/constants.dart';

import 'package:kin_music_player_app/screens/genre/components/genre_app_bar.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/genre_provider.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';

class GenreDetail extends StatefulWidget {
  final Genre genre;
  const GenreDetail({Key? key, required this.genre}) : super(key: key);
  static String routName = '/genreDetail';

  @override
  State<GenreDetail> createState() => _GenreDetailState();
}

class _GenreDetailState extends State<GenreDetail> {
  static const _pageSize = 0;

  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchMoreAlbums(pageKey);
    });
    super.initState();
  }

  Future _fetchMoreAlbums(pageKey) async {
    try {
      GenreProvider genreProvider = Provider.of<GenreProvider>(context);
      final newItems = await genreProvider.getAllTracksByGenreId(
          genreId: widget.genre.id.toString(), pageKey: pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<GenreProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: FutureBuilder(
        future: albumProvider.getAllTracksByGenreId(
            genreId: widget.genre.id.toString(), pageKey: _pageSize),
        builder: (context, snapshot) {
          // loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: KinProgressIndicator(),
              ),
            );
          }

          // success state
          else if (snapshot.hasData && !snapshot.hasError) {
            List<Music> allTracksUnderGenre = snapshot.data as List<Music>;
            return SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[GenreAppBar(genre: widget.genre)];
                },
                body: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        '$kinAssetBaseUrl/${widget.genre.cover}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: allTracksUnderGenre.isEmpty
                        ? const Center(
                            child: Text(
                              "No Tracks",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: getProportionateScreenWidth(20),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            );
          }

          // fail state
          else {
            return Text(snapshot.toString());
          }
        },
      ),
    );
  }
}
