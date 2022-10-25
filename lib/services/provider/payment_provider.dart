import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/payment_service.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  bool isLoading = false;

  PaymentApiService paymentApiService = PaymentApiService();

  isBought(context) {
    bool isBought = Provider.of<MusicPlayer>(context, listen: false)
        .currentMusic!
        .isPurchasedByUser;
    if (isBought == false) {
      isBought = true;
    }
  }

  Future saveUserPaymentAndTrackInfo({
    required double paymentAmount,
    required String paymentMethod,
    required String paymentState,
    required String trackId,
    required Function onPaymentCompleteFunction,
  }) async {
    isLoading = true;

    await paymentApiService.saveUserPaymentAndTrackInfo(
      paymentAmount: paymentAmount,
      paymentMethod: paymentMethod,
      paymentState: paymentState,
      trackId: trackId,
    );

    isLoading = false;

    notifyListeners();
  }
}
