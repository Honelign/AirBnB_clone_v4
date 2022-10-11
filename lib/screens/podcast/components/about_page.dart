import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: Text(
            "About Page",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
