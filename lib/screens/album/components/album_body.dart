import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

import 'playlist_card.dart';

class AlbumBody extends StatefulWidget {
  static String routeName = '/decoration';

  final Album album;
  final List<Music> albumMusicsFromCard;

  const AlbumBody({
    Key? key,
    required this.album,
    required this.albumMusicsFromCard,
  }) : super(key: key);

  @override
  State<AlbumBody> createState() => _AlbumBodyState();
}

class _AlbumBodyState extends State<AlbumBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  '$kinAssetBaseUrl/${widget.album.cover}',
                ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // _buildTitleSection(widget.album),

                          // back button
                          Container(
                            padding: const EdgeInsets.fromLTRB(4, 12, 4, 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _buildBackButton(context),
                              ],
                            ),
                            height: 45,
                            width: MediaQuery.of(context).size.width,
                          ),

                          // spacer
                          const SizedBox(
                            height: 16,
                          ),

                          // Album Art
                          _buildAlbumArt(
                            "$kinAssetBaseUrl/${widget.album.cover}",
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Text(
                            widget.album.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.album.artist,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),
                          // Text(
                          //   widget.album.count == 0
                          //       ? "No items"
                          //       : widget.album.count == 1
                          //           ? "1 item"
                          //           : widget.album.count.toString() + " items",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 10,
                          //   ),
                          // ),

                          // _buildAlbumInfo(),
                          // _buildPlayAllIcon(
                          //   context,
                          //   widget.albumMusicsFromCard,
                          // )

                          const SizedBox(
                            height: 16,
                          ),

                          // button
                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 9,
                                horizontal: 30,
                              ),
                              decoration: BoxDecoration(
                                color: kPopupMenuBackgroundColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.shuffle_rounded,
                                    color: kSecondaryColor,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    "Shuffle All",
                                    style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Expanded(
                        child: _buildAlbumMusics(widget.albumMusicsFromCard,
                            context, widget.album.id),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumArt(image) {
    return CachedNetworkImage(
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20),
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

  Widget _buildAlbumMusics(musics, context, id) {
    return FutureBuilder<List<Music>>(
      future: Provider.of<MusicProvider>(context, listen: false)
          .albumMusicsGetter(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const KinProgressIndicator();
        }
        List<Music> albumMusics = snapshot.data ?? [];
        return ListView.builder(
          itemCount: albumMusics.length,
          itemBuilder: (context, index) {
            return AlbumCard(
              albumMusics: albumMusics,
              music: albumMusics[index],
              musicIndex: index,
              album: widget.album,
            );
          },
        );
      },
    );
  }
}
