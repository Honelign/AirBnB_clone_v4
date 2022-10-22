import 'package:flutter/material.dart';
import 'package:kin_music_player_app/size_config.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(200),
      child: Stack(
        children: [
          Positioned(
            top: getProportionateScreenHeight(100),
            child: Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: 80,
            ),
            right: getProportionateScreenWidth(50),
            left: getProportionateScreenWidth(50),
          ),
        ],
      ),
    );
  }
}
