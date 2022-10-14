import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music/playlist_info.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistTitleDisplay extends StatefulWidget {
  PlaylistInfo playlistInfo;
  Function refreshFunction;
  PlaylistTitleDisplay(
      {Key? key, required this.playlistInfo, required this.refreshFunction})
      : super(key: key);

  @override
  State<PlaylistTitleDisplay> createState() => _PlaylistTitleDisplayState();
}

class _PlaylistTitleDisplayState extends State<PlaylistTitleDisplay> {
  late PlayListProvider playlistProvider;

  @override
  void initState() {
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayListProvider>(
      builder: ((context, playlistProvider, child) {
        // display
        return Container(
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(5),
          ),
          child: playlistProvider.isLoading == true
              ? const Center(
                  child: KinProgressIndicator(),
                )
              : Row(
                  children: [
                    // icon
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        "assets/icons/Playlist Icon.png",
                        width: 26,
                        height: 26,
                      ),
                    ),

                    // spacer
                    const SizedBox(
                      width: 12,
                    ),

                    // title
                    Text(
                      widget.playlistInfo.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton(
                            initialValue: 0,
                            color: Colors.white,
                            child: const Icon(
                              Icons.more_vert,
                              color: kGrey,
                            ),
                            onSelected: (value) async {
                              if (value == 1) {
                                // delete playlist
                                bool response =
                                    await playlistProvider.deletePlaylist(
                                  playlistId: widget.playlistInfo.id.toString(),
                                );

                                if (response == true) {
                                  kShowToast(
                                    message:
                                        "Playlist ${widget.playlistInfo.name} deleted",
                                  );
                                  widget.refreshFunction();
                                } else {
                                  kShowToast(
                                    message:
                                        "Could not delete ${widget.playlistInfo.name}",
                                  );
                                }
                              } else {}
                            },
                            itemBuilder: (context) {
                              return kPlaylistTitleCardsPopupMenuItems;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
