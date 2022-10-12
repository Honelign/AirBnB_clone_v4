import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class SeasonsPage extends StatelessWidget {
  const SeasonsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text(
            "Seasons Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
