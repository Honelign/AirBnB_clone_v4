import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kin_music_player_app/components/no_connection_display.dart';
import 'package:kin_music_player_app/components/on_snapshot_error.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_body.dart';
import 'package:kin_music_player_app/screens/playlist/components/playlist_title.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/connectivity_service.dart';
import 'package:kin_music_player_app/services/network/model/music/playlist_info.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import '../../components/kin_progress_indicator.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  late PlayListProvider playListProvider;
  static const _pageSize = 1;
  final PagingController<int, PlaylistInfo> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    playListProvider = Provider.of(context, listen: false);

    _pagingController.addPageRequestListener(
      (pageKey) {
        _fetchMorePlaylists(pageKey);
      },
    );
    super.initState();
  }

  void refreshFunction() {
    _pagingController.refresh();
    setState(() {});
  }

  Future _fetchMorePlaylists(int pageKey) async {
    try {
      final newItems = await playListProvider.getPlayList(pageKey: pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
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
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    // text controller
    TextEditingController playlistNameController = TextEditingController();
    return Scaffold(
      backgroundColor: Color(0xFF052c54),
      body: SafeArea(
        child: checkConnection(status) == false
            ? RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                backgroundColor: refreshIndicatorBackgroundColor,
                color: refreshIndicatorForegroundColor,
                child: NoConnectionDisplay(),
              )
            : FutureBuilder(
                future: playListProvider.getPlayList(),
                builder: (context, AsyncSnapshot<List<PlaylistInfo>> snapshot) {
                  // loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: KinProgressIndicator(),
                    );
                  }

                  // data loaded
                  else if (snapshot.hasData && !snapshot.hasError) {
                    return Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF052C54),
                          const Color(0xFFD9D9D9).withOpacity(0.7)
                        ],
                      )),
                      padding: const EdgeInsets.fromLTRB(0, 24, 0, 36),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _pagingController.refresh();
                        },
                        backgroundColor: refreshIndicatorBackgroundColor,
                        color: refreshIndicatorForegroundColor,
                        child: PagedListView<int, PlaylistInfo>(
                          pagingController: _pagingController,
                          builderDelegate:
                              PagedChildBuilderDelegate<PlaylistInfo>(
                            animateTransitions: true,
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            noItemsFoundIndicatorBuilder: (context) => SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Column(children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 8.0, right: 180),
                                  child: Text(
                                    "Your Playlist",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 150),
                                Text(
                                  "No Playlist",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Add your first playlist",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ]),
                            ),
                            noMoreItemsIndicatorBuilder: (_) => Container(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 32),
                              child: const Center(
                                child: Text(
                                  "No More Playlists",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            firstPageProgressIndicatorBuilder: (_) =>
                                const KinProgressIndicator(),
                            newPageProgressIndicatorBuilder: (_) =>
                                const KinProgressIndicator(),
                            itemBuilder: ((context, item, index) {
                              return InkWell(
                                onTap: () {
                                  // go to detail page
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PlaylistBody(
                                        playlistId: item.id,
                                        playlistName: item.name,
                                      ),
                                    ),
                                  );
                                },
                                child: PlaylistTitleDisplay(
                                  playlistInfo: item,
                                  refreshFunction: refreshFunction,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    );
                  }

                  // error
                  else {
                    return OnSnapshotError(error: snapshot.error.toString());
                  }
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecondaryColor,
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) {
              return Consumer<PlayListProvider>(
                builder: (BuildContext context, playListProvider, _) {
                  return SimpleDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: kLightTextColor,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    elevation: 10,
                    children: playListProvider.isLoading == false
                        ? [
                            // title

                            // Input
                            TextField(
                              controller: playlistNameController,
                              cursorColor: kGrey,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 0),
                                hintText: "Playlist Name",
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: kSecondaryColor.withOpacity(0.5),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ),
                            ),

                            // Spacer
                            const SizedBox(
                              height: 48,
                            ),

                            // controls
                            Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(
                                horizontal: getProportionateScreenWidth(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Separator

                                  // Create Button
                                  InkWell(
                                    onTap: () async {
                                      // empty text
                                      if (playlistNameController.text == "") {
                                        kShowToast(
                                            message: "Invalid Playlist name");
                                      } else {
                                        await playListProvider.createPlayList(
                                          playlistName:
                                              playlistNameController.text,
                                        );
                                        await playListProvider.getPlayList();
                                        playlistNameController.text = "";

                                        Navigator.pop(context, true);
                                        refersh();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.black,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 16,
                                      ),
                                      child: const Text(
                                        "Create Playlist",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                        : [
                            const Center(
                              child: KinProgressIndicator(),
                            )
                          ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void refersh() {
    _pagingController.refresh();
  }
}
