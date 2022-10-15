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
          horizontal: getProportionateScreenWidth(20),
        ),
        height: 112,
        width: 112,
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              // BoxShadow(
              //   offset: Offset(-7, 7),
              //   spreadRadius: -5,
              //   blurRadius: 5,
              //   color: Color.fromRGBO(0, 0, 0, 0.16),
              // )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 4.0,
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.attach_money_outlined,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Buy Coins",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
