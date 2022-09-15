import 'package:flutter/material.dart';
import 'package:kin_music_player_app/coins/components/coin_icon.dart';
import 'package:kin_music_player_app/coins/components/purchase_coin_card.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/provider/coin_provider.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:provider/provider.dart';

class BuyCoinPage extends StatefulWidget {
  const BuyCoinPage({Key? key}) : super(key: key);

  @override
  State<BuyCoinPage> createState() => _BuyCoinPageState();
}

class _BuyCoinPageState extends State<BuyCoinPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CoinProvider>(context, listen: false);

    // will be passed down to child to refresh state
    void refreshFunction() {
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Coins"),
        backgroundColor: kPrimaryColor,
      ),
      body: FutureBuilder(
        future: provider.getCoinBalance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const KinProgressIndicator();
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 12),
              color: kPrimaryColor,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // title
                    Text(
                      "Coins Balance",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(
                      height: 24,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // static icon
                        const CoinIcon(),

                        // spacing
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),

                        // amount of remaining coins
                        Text(
                          snapshot.data != "" && snapshot.data != null
                              ? "${snapshot.data} ETB"
                              : "0 ETB",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // spacer
                    const SizedBox(
                      height: 48,
                    ),

                    // Action Section
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                          itemCount: allowedCoinValues.length,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            // card component
                            return PurchaseCoinCard(
                              value: allowedCoinValues[index],
                              refresher: refreshFunction,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
