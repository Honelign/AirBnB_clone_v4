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
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF052C54),
              const Color(0xFFD9D9D9).withOpacity(0.7)
            ],
          )),
          child: ListView(
            children: [
              /*  const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 180),
                child: Text(
                  "Downloads",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ), */
              FutureBuilder<List<Music>>(
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
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      child: const Center(
                        child: Text(
                          "No Downloads",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    backgroundColor: refreshIndicatorBackgroundColor,
                    color: refreshIndicatorForegroundColor,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void refresherFunction() {
    setState(() {});
  }
}
