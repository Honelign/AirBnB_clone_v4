import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/music/album.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistListCard extends StatefulWidget {
  final double height, aspectRatio;
  final Music music;
  final int musicIndex;
  final List<Music> musics;
  final Function refresherFunction;

  int? playlistId;

  PlaylistListCard({
    Key? key,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.musics,
    required this.music,
    required this.musicIndex,
    this.playlistId,
    required this.refresherFunction,
  }) : super(key: key);

  @override
  State<PlaylistListCard> createState() => _PlaylistListCardState();
}

class _PlaylistListCardState extends State<PlaylistListCard> {
  late PlayListProvider playlistProvider;

  @override
  void initState() {
    playlistProvider = Provider.of<PlayListProvider>(context, listen: false);
    print("@lookie + ${widget.musics}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    var p = Provider.of<MusicPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicProvider>(context);
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return GestureDetector(
          onTap: () {
            incrementMusicView(widget.music.id);
            p.albumMusicss = widget.musics;
            p.setBuffering(widget.musicIndex);
            if (checkConnection(status)) {
              if (p.isMusicInProgress(widget.music)) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NowPlayingMusic(widget.music),
                  ),
                );
              } else {
                radioProvider.player.stop();
                podcastProvider.player.stop();
                p.player.stop();

                p.setMusicStopped(true);
                podcastProvider.setEpisodeStopped(true);
                p.listenMusicStreaming();
                podcastProvider.listenPodcastStreaming();

                p.setPlayer(p.player, podcastProvider, radioProvider);
                radioProvider.setMiniPlayerVisibility(false);
                p.handlePlayButton(
                  music: widget.music,
                  index: widget.musicIndex,
                  album: Album(
                    id: -2,
                    title: 'Single Music ${widget.musicIndex}',
                    artist: 'kin',
                    description: '',
                    cover: 'assets/images/kin.png',
                    count: widget.musics.length,
                    artist_id: 1,
                    isPurchasedByUser: false,
                    price: 60,
                  ),
                  musics: widget.musics,
                );

                p.setMusicStopped(false);
                podcastProvider.setEpisodeStopped(true);
                p.listenMusicStreaming();
                podcastProvider.listenPodcastStreaming();

                // add to recently played
                musicProvider.addToRecentlyPlayed(music: widget.music);

                // add to popular
                musicProvider.countPopular(music: widget.music);
              }
            } else {
              kShowToast();
            }
          },
          child: Container(
            height: getProportionateScreenHeight(widget.height),
            width: getProportionateScreenWidth(75),
            margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1.02,
                    child: Container(
                      color: kSecondaryColor.withOpacity(0.1),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: '$kinAssetBaseUrl/${widget.music.cover}',
                      ),
                    ),
                  ),
                ),

                // Spacer
                SizedBox(
                  width: getProportionateScreenWidth(10),
                ),

                //
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Music Title
                          Text(
                            widget.music.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                          // Artist Title
                          Text(
                            widget.music.artist.isNotEmpty
                                ? widget.music.artist
                                : 'kin artist',
                            style: const TextStyle(color: kGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          p.currentMusic == null
                              ? Container()
                              : p.currentMusic!.title == widget.music.title
                                  ? TrackMusicPlayButton(
                                      music: widget.music,
                                      index: widget.musicIndex,
                                      album: Album(
                                        id: -2,
                                        title:
                                            'Single Music ${widget.musicIndex}',
                                        artist: 'kin',
                                        description: '',
                                        cover: 'assets/images/kin.png',
                                        count: widget.musics.length,
                                        artist_id: 1,
                                        isPurchasedByUser: false,
                                        price: 60,
                                      ),
                                    )
                                  : Container()
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton(
                  initialValue: 0,
                  child: const Icon(
                    Icons.more_vert,
                    color: kGrey,
                  ),
                  color: kPopupMenuBackgroundColor,
                  onSelected: (value) async {
                    if (value == 2) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: kPopupMenuBackgroundColor,
                              title: const Text(
                                'Music Detail',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 15,
                                ),
                              ),
                              content: SizedBox(
                                height: 100,
                                child: Column(
                                  children: [
                                    Text(
                                      widget.music.description.isNotEmpty
                                          ? widget.music.description
                                          : '',
                                      style: const TextStyle(
                                        color: kLightSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      'By ${widget.music.artist}',
                                      style: const TextStyle(
                                        color: kLightSecondaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      playlistProvider.isLoading = true;
                      widget.refresherFunction();
                      bool response =
                          await playlistProvider.deleteTrackFromPlaylist(
                        trackIdInPlaylist:
                            widget.music.trackIdInPlaylist.toString(),
                      );
                      playlistProvider.isLoading = false;

                      if (response == true) {
                        kShowToast(message: "${widget.music.title} removed");
                        widget.refresherFunction();
                      } else {
                        kShowRetry(
                          message: "${widget.music.title} could not be removed",
                        );
                      }
                    }
                  },
                  itemBuilder: (context) {
                    return kPlaylistPopupMenuItem;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
