import 'package:flutter/material.dart';
import 'package:kin_music_player_app/coins/components/coin_icon.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/payment/coin_payment_component.dart';
import 'package:kin_music_player_app/constants.dart';

class PurchaseCoinCard extends StatefulWidget {
  final String value;
  final Function refresher;
  const PurchaseCoinCard(
      {Key? key, required this.value, required this.refresher})
      : super(key: key);

  @override
  State<PurchaseCoinCard> createState() => _PurchaseCoinCardState();
}

class _PurchaseCoinCardState extends State<PurchaseCoinCard> {
  bool isButtonLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      width: MediaQuery.of(context).size.width,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon and value
          Row(
            children: [
              const CoinIcon(),
              const SizedBox(
                width: 12,
              ),
              Text(
                widget.value + " ETB",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(
                    0.75,
                  ),
                ),
              ),
            ],
          ),

          // Button
          InkWell(
            onTap: () async {
              setState(() {
                isButtonLoading = true;
              });

              // show payment modal
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => CoinPaymentComponent(
                  trackId: 0,
                  paymentPrice: widget.value,
                  onSuccessFunction: widget.refresher,
                  paymentReason: "tip",
                ),
              );
            },
            child: isButtonLoading == true
                ? const Center(
                    child: KinProgressIndicator(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: kSecondaryColor.withOpacity(0.75),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Center(
                      child: Text(
                        "Recharge",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
