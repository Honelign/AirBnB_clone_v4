import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'playlist_card.dart';

class AlbumBody extends StatefulWidget {
  static String routeName = '/decoration';

  final Album album;

  const AlbumBody({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  State<AlbumBody> createState() => _AlbumBodyState();
}

class _AlbumBodyState extends State<AlbumBody> {
  List<Music> albumMusicss = [];
  @override
  void initState() {
    Provider.of<MusicProvider>(context, listen: false)
        .albumMusicsGetter(widget.album.id);
    // TODO: implement initState
    albumMusicss =
        Provider.of<MusicProvider>(context, listen: false).albumMusics;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  var p= Provider.of<MusicProvider>(context,listen: false);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  '$kinAssetBaseUrl/${widget.album.cover}'),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
            child: Container(
                color: kPrimaryColor.withOpacity(0.5),
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(280),
                      child: Stack(
                        children: [
                          _buildAlbumArt(widget.album.cover),
                          _buildTitleSection(widget.album),
                          _buildBackButton(context),
                          _buildAlbumInfo(),
                          _buildPlayAllIcon(context, albumMusicss)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(15),
                    ),
                    Expanded(
                      child: _buildAlbumMusics(albumMusicss, context),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt(image) {
    return Stack(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(245),
          width: double.infinity,
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: '$kinAssetBaseUrl/$image',
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF343434).withOpacity(0.4),
                const Color(0xFF343434).withOpacity(0.15),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTitleSection(Album album) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: getProportionateScreenHeight(30)),
        alignment: Alignment.topLeft,
        height: getProportionateScreenHeight(75),
        width: double.infinity,
        color: kPrimaryColor.withOpacity(0.3),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(15.0),
          vertical: getProportionateScreenWidth(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              album.artist,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              album.title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return BackButton(
      color: Colors.white,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildAlbumInfo() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        height: getProportionateScreenHeight(280) -
            getProportionateScreenHeight(245),
        width: double.infinity,
        color: kPrimaryColor.withOpacity(0.5),
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(10),
            vertical: getProportionateScreenHeight(5)),
        child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "${widget.album.count} songs",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w600),
            )),
      ),
    );
  }

  Widget _buildPlayAllIcon(context, musics) {
    var playerProvider = Provider.of<MusicPlayer>(
      context,
    );
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var musicProvider = Provider.of<MusicPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: PlayerBuilder.isPlaying(
          player: playerProvider.player,
          builder: (context, isPlaying) {
            return InkWell(
              onTap: () {
                if (playerProvider.currentMusic == null) {
                  if (checkConnection(status)) {
                    radioProvider.player.stop();
                    podcastProvider.player.stop();

                    podcastProvider.setEpisodeStopped(true);
                    podcastProvider.listenPodcastStreaming();

                    musicProvider.setPlayer(
                        musicProvider.player, podcastProvider, radioProvider);
                    playerProvider.handlePlayButton(
                        musics: albumMusicss,
                        album: widget.album,
                        music: musics[0],
                        index: 0);
                    podcastProvider.setEpisodeStopped(true);
                    podcastProvider.listenPodcastStreaming();
                  } else {
                    kShowToast();
                  }
                } else if (playerProvider.player.getCurrentAudioTitle ==
                        playerProvider.currentMusic!.title &&
                    widget.album.id == playerProvider.currentAlbum.id) {
                  if (isPlaying || playerProvider.player.isBuffering.value) {
                    playerProvider.player.pause();
                  } else {
                    if (checkConnection(status)) {
                      playerProvider.player.play();
                    } else {
                      kShowToast();
                    }
                  }
                } else {
                  if (checkConnection(status)) {
                    radioProvider.player.stop();
                    podcastProvider.player.stop();
                    playerProvider.player.stop();

                    playerProvider.setMusicStopped(true);
                    podcastProvider.setEpisodeStopped(true);
                    playerProvider.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();

                    playerProvider.setPlayer(
                        playerProvider.player, podcastProvider, radioProvider);
                    playerProvider.handlePlayButton(
                        musics: albumMusicss,
                        album: widget.album,
                        music: musics[0],
                        index: 0);
                    playerProvider.setMusicStopped(false);
                    podcastProvider.setEpisodeStopped(true);
                    playerProvider.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();
                  } else {
                    kShowToast();
                  }
                }
              },
              child: Container(
                width: 50,
                height: 50,
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 15,
                  child: !playerProvider.isMusicLoaded
                      ? SpinKitFadingCircle(
                          itemBuilder: (BuildContext context, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color: index.isEven
                                    ? kSecondaryColor
                                    : Colors.white,
                              ),
                            );
                          },
                          size: 30,
                        )
                      : SvgPicture.asset(
                          isPlaying &&
                                  widget.album.id ==
                                      playerProvider.currentAlbum.id
                              ? 'assets/icons/pause.svg'
                              : 'assets/icons/play.svg',
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAlbumMusics(musics, context) {
    return ListView.builder(
        itemCount: musics.length,
        itemBuilder: (context, index) {
          return AlbumCard(
            albumMusics: musics,
            music: musics[index],
            musicIndex: index,
            album: widget.album,
          );
        });
  }
}
