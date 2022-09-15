import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/music_list_card.dart';
import 'package:kin_music_player_app/components/section_title.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/provider/drop_down_provider.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../size_config.dart';

class PlayLists extends StatefulWidget {
  final String? sectionTitle;
  final bool? hasSeeMore;

  const PlayLists({Key? key, this.sectionTitle = '', this.hasSeeMore = false})
      : super(key: key);

  @override
  State<PlayLists> createState() => _PlayListsState();
}

class _PlayListsState extends State<PlayLists> {
  int selectedPlaylistId = 1;

  @override
  Widget build(BuildContext context) {
    var futureVal = context.read<PlayListProvider>().getPlayList();
    TextEditingController playlistTitle = TextEditingController();
    int index = 0;
    return Scaffold(
      // wrapping the scaffold with consumer;
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      body: FutureBuilder(
        future: futureVal,
        builder: (context, AsyncSnapshot<List<PlaylistTitle?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                final provider = Provider.of<DropDownProvider>(context);
                if (provider.dropdownTitle != null) {
                  index = snapshot.data!.indexOf(provider.dropdownTitle);
                  if (index == -1) {
                    index = 0;
                  }
                }
                return SafeArea(
                  child: Consumer<PlayListProvider>(
                    builder: (ctx, playlistProvider, _) {
                      return NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            _playListAppBar(
                                context, playlistProvider.musics, index)
                          ];
                        },
                        body: _buildMusicList(
                          context,
                          playlistProvider.musics.isNotEmpty
                              ? playlistProvider.musics[index].playlists
                              : [],
                        ),
                      );
                    },
                  ),
                );
              }
            }
            return const SafeArea(
              child: Center(
                child: Text(
                  'No Playlist',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
          return const SafeArea(
            child: Center(
              child: KinProgressIndicator(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => SizedBox(
              height: getProportionateScreenHeight(340) +
                  MediaQuery.of(context).viewInsets.bottom,
              width: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kGrey.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        top: getProportionateScreenHeight(50),
                        left: getProportionateScreenWidth(50),
                        right: getProportionateScreenWidth(50),
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(60),
                          width: getProportionateScreenWidth(250),
                          child: TextField(
                              controller: playlistTitle,
                              cursorColor: kGrey,
                              style: const TextStyle(color: kGrey),
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: kGrey),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(10),
                                    vertical: getProportionateScreenHeight(10),
                                  ),
                                  hintText: 'Playlist name',
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: kGrey.withOpacity(0.25))),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: kGrey.withOpacity(0.25),
                                    ),
                                  ),
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  fillColor: kGrey.withOpacity(0.25),
                                  filled: true)),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(25),
                        ),
                        InkWell(
                          onTap: () async {
                            final provider = Provider.of<PlayListProvider>(
                                context,
                                listen: false);
                            if (playlistTitle.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter valid text'),
                                ),
                              );
                            } else {
                              var result = await provider
                                  .createPlayList(playlistTitle.text);

                              setState(
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(result),
                                    ),
                                  );
                                },
                              );
                            }
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenHeight(5),
                              horizontal: getProportionateScreenWidth(15),
                            ),
                            width: getProportionateScreenWidth(145),
                            height: getProportionateScreenHeight(50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: kSecondaryColor,
                            ),
                            child: const Text(
                              'Create playlist',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(1000)),
          height: getProportionateScreenHeight(65),
          width: getProportionateScreenWidth(50),
          child: const Icon(
            Icons.add,
            size: 25,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildMusicList(BuildContext context, List<PlayList> list) {
    List<Music> playlistMusics = [];
    for (int i = 0; i < list.length; i++) {
      playlistMusics.add(list[i].music!);
    }
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: widget.hasSeeMore!
              ? SectionTitle(title: widget.sectionTitle!, press: () {})
              : Container(),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        list.isEmpty
            ? const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'No music added to this playlist',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return MusicListCard(
                      music: list[index].music,
                      musics: playlistMusics,
                      musicIndex: index,
                      isForPlaylist: true,
                      playlistId: list[index].id);
                })
      ]),
    );
  }

  Widget _playListAppBar(
      BuildContext context, List<PlaylistTitle> data, index) {
    return SliverAppBar(
      expandedHeight: 175,
      pinned: true,
      backgroundColor: kPrimaryColor,
      elevation: 2,
      automaticallyImplyLeading: false,
      title: const Text('My Playlist'),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 75),
        child: _buttonBar(context, data, index),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF343434).withOpacity(0.4),
                    const Color(0xFF343434).withOpacity(0.7),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buttonBar(context, List<PlaylistTitle> data, index) {
    PlaylistTitle value = data[index];
    selectedPlaylistId = data[index].id;
    return Container(
      width: double.infinity,
      color: kGrey.withOpacity(0.2),
      height: getProportionateScreenHeight(75),
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Consumer<DropDownProvider>(
              builder: (ctx, provider, _) {
                return DropdownButton<PlaylistTitle>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    value: value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (val) {
                      provider.setPlaylist(val!);
                      // setState(() {
                      //   selectedPlaylistId = val!.id;
                      // });
                    },
                    hint: Text(
                      value.title,
                    ),
                    underline: Container(),
                    items: data.map((PlaylistTitle playlist) {
                      return DropdownMenuItem<PlaylistTitle>(
                        key: Key(playlist.id.toString()),
                        value: playlist,
                        child: Text(playlist.title),
                      );
                    }).toList());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              initialValue: 0,
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return kDeletePlaylistTitle;
              },
              onSelected: (value) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: kPrimaryColor,
                      title: const Text(
                        'Are you sure? Musics under this playlist will also be deleted',
                        style: TextStyle(color: Colors.white60, fontSize: 15),
                      ),
                      actions: [
                        Consumer<DropDownProvider>(
                          builder: (context, provider, _) {
                            return TextButton(
                                onPressed: () async {
                                  var id = data.length == 1
                                      ? selectedPlaylistId
                                      : provider.playlistId;
                                  setState(() {
                                    context
                                        .read<PlayListProvider>()
                                        .deletePlaylistTitle(id);
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Successfully Deleted'),
                                    ),
                                  );

                                  // TODO:Improve implementation
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PlayLists()));
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: kSecondaryColor),
                                ));
                          },
                        ),
                        TextButton(
                          child: const Text('No',
                              style: TextStyle(color: kSecondaryColor)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
