import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/provider/offline_play_provider.dart';
import 'package:provider/provider.dart';

class DownloadProgressDisplayComponent extends StatelessWidget {
  const DownloadProgressDisplayComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OfflineMusicProvider>(
      create: (context) => OfflineMusicProvider(),
      child: Consumer<OfflineMusicProvider>(
        builder: (BuildContext context, offlineProvider, _) {
          return AlertDialog(
            backgroundColor: kPopupMenuBackgroundColor,
            title: const Text(
              'Downloading...',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),
            content: SizedBox(
              height: 100,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      offlineProvider.currentDownloadFileName,
                      style: const TextStyle(color: kLightSecondaryColor),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'By artist',
                      style: const TextStyle(color: kLightSecondaryColor),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
