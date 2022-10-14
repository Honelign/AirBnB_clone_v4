import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/model/music/music.dart';

class MusicDetailDisplay extends StatelessWidget {
  final Music music;
  const MusicDetailDisplay({Key? key, required this.music}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.85),
      title: const Text(
        'Music Detail',
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
                music.description.isNotEmpty ? music.description : '',
                style: const TextStyle(color: kLightSecondaryColor),
                textAlign: TextAlign.center,
              ),
              Text(
                'By ${music.artist}',
                style: const TextStyle(color: kLightSecondaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
