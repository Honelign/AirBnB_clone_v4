import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentProvider extends ChangeNotifier {
  bool isLoading = false;

  Future savePaymentInfo(
      {required double paymentAmount,
      required String paymentMethod,
      required String paymentState,
      required String track_id,
      }) async {
    isLoading = true;
    String apiEndPoint = "/payment";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("id") ?? "";
    debugPrint('asdhgajsd${paymentAmount}${paymentMethod}${userId}');

    if (userId != "") {
      await saveUserPaymentInfo(
          paymentAmount: paymentAmount,
          paymentMethod: paymentMethod,
          paymentState: paymentState,
          userId: userId,
          track_id:track_id,
          );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<dynamic> verifyPurchase(
      context, pay_id, String userId, String payment_amount, track_id) async {
    isLoading = true;
    String endPoint = 'http://104.199.33.9/payment/purchased-tracks/';
   
    debugPrint("p_id=${pay_id}trackid=${track_id}");
    if (userId != "") {
      await verifyTrack(context, pay_id, userId, payment_amount, track_id);
    }
    isLoading = false;
    notifyListeners();
  }
}


