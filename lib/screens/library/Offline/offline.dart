import 'package:flutter/material.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/screens/library/Offline/components/offline_music_card.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:provider/provider.dart';

class Offline extends StatefulWidget {
  const Offline({Key? key}) : super(key: key);

  @override
  State<Offline> createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  @override
  Widget build(BuildContext context) {
    OfflineMusicProvider _offlineMusicProvider =
        Provider.of<OfflineMusicProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: FutureBuilder<List<Music>>(
          future: _offlineMusicProvider.getOfflineMusic(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                _offlineMusicProvider.isLoading == true) {
              return const Center(
                child: KinProgressIndicator(),
              );
            }

            // empty

            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No Offline Tracks",
                  style: headerTextStyle,
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: kPrimaryColor,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length ?? 0,
                    itemBuilder: (context, index) {
                      return OfflineMusicCard(
                        music: snapshot.data![index],
                        musics: snapshot.data! ?? [],
                        musicIndex: index,
                        refresherFunction: refresherFunction,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void refresherFunction() {
    setState(() {});
  }
}
