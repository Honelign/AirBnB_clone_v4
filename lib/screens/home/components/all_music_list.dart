import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class AllMusicList extends StatefulWidget {
  int? from;
  AllMusicList({Key? key, this.from}) : super(key: key);
  static String routeName = 'allMusicList';

  @override
  State<AllMusicList> createState() => _AllMusicListState();
}

class _AllMusicListState extends State<AllMusicList> {
  static const _pageSize = 10;
  final PagingController<int, Music> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchMoreMusic(pageKey);
    });
    super.initState();
  }

  Future<void> fetchMoreMusic(pagekey) async {
    final provider = Provider.of<MusicPlayer>(context, listen: false);

    List<Music> music = [];
    try {
      var page = (pagekey / 10).toInt() + 1;
      music = widget.from == 1
          ? await fetchMore(page)
          : await fetchMorePopular(page);
      final isLastPage = music.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(music);
        widget.from == 1
            ? provider.setRecentMusicList(music)
            : provider.setPopularMusicList(music);
      } else {
        final nextPageKey = pagekey + music.length;
        _pagingController.appendPage(music, nextPageKey);
        widget.from == 1
            ? provider.setRecentMusicList(music)
            : provider.setPopularMusicList(music);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // 4
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<MusicPlayer>(context, listen: false);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text('Musics'),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Music>.separated(
          pagingController: _pagingController,
          shrinkWrap: true,
          builderDelegate: PagedChildBuilderDelegate<Music>(
            itemBuilder: (context, music, index) {
              return MusicListCard(
                music: music,
                musics: widget.from == 1
                    ? p.getRecentMusicsList
                    : p.getPopularMusicsList,
                musicIndex: index,
              );
            },
            firstPageErrorIndicatorBuilder: (context) => InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text(
                    "No Additional Item",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // onTap: () => _pagingController.refresh(),
            ),
            noMoreItemsIndicatorBuilder: (context) => const Center(
                child: Text(
              'Reached to the end',
              style: TextStyle(color: Colors.white),
            )),
            noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Text(
              'None',
              style: TextStyle(color: Colors.white),
            )),
          ),
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const Divider(
            thickness: 1,
          ),
        ),
      ),
    );
  }
}

//
// body: SingleChildScrollView(
// child: Column(
//
// children: [
//
// SizedBox(height: getProportionateScreenWidth(15)),
// FutureBuilder(
// future: provider.getMusics(),
// builder: (context, AsyncSnapshot <List<Music>> snapshot) {
//
// if (snapshot.hasData ) {
// if(provider.isLoading){
// return const Center(
// child: CircularProgressIndicator(),
// );
// }
//
// return ListView.builder(
// itemCount:snapshot.data!.length,
// scrollDirection: Axis.vertical,
// shrinkWrap: true,
// physics: const NeverScrollableScrollPhysics(),
// itemBuilder: (context, index){

// return MusicListCard(music:snapshot.data![index],musics: snapshot.data!,);
// });
//
// }
//
// return const CircularProgressIndicator();
// })
//
// ],
//
// ),),
// ListView.builder(
//     itemCount: snapshot.data!.length,
//     scrollDirection: Axis.vertical,
//     shrinkWrap: true,
//     physics: const NeverScrollableScrollPhysics(),
//     itemBuilder: (context, index) {
//
//       return MusicListCard(music: snapshot.data![index]);
//     });
