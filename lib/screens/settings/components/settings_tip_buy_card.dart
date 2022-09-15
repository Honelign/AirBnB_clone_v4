import 'package:flutter/material.dart';
import 'package:kin_music_player_app/coins/buy_coin.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class BuyTipCurrency extends StatelessWidget {
  const BuyTipCurrency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // go to purchase coin page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BuyCoinPage(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15),
            horizontal: getProportionateScreenWidth(20)),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(
            MdiIcons.currencyUsd,
            color: Colors.white.withOpacity(0.75),
          ),
          title: Text(
            'Buy Coins',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ),
      ),
    );
  }
}
