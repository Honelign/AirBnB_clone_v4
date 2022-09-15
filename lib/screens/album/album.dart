import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/grid_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/provider/album_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> {
  static const _pageSize = 6;
  final PagingController<int, Album> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  Future fetchMoreAlbums(pageKey) async {}

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albumProvider = Provider.of<AlbumProvider>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.only(top: getProportionateScreenHeight(30)),
        child: FutureBuilder(
          future: albumProvider.getAlbums(),
          builder: (BuildContext context, AsyncSnapshot<List<Album>> snapshot) {
            // loading
            if (albumProvider.isLoading &&
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
            }

            // no connection
            else if (albumProvider.isLoading &&
                !(snapshot.connectionState == ConnectionState.active)) {
              return ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.3),
                    child: Center(
                      child: Text(
                        kConnectionErrorMessage,
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ),
                  )
                ],
              );
            }

            // Data fetched
            else if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List<Album> allAlbums = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext ctx, index) {
                  return GridCard(album: allAlbums[index]);
                },
              );
            }

            return const Text(
              "No Albums",
              style: TextStyle(color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
