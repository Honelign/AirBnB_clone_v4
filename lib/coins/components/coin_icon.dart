import 'package:flutter/material.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CoinIcon extends StatelessWidget {
  const CoinIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      // color: Colors.green,
      decoration: BoxDecoration(
        border: Border.all(
          color: kLightTextColor,
          width: 2.0,
        ),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        MdiIcons.currencyUsd,
        color: kLightTextColor,
      ),
    );
  }
}
