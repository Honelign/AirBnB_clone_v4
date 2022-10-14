import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api/music_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';

class PaymentApiService {
  final String fileName = "payment_service.dart";
  final String className = "PaymentApiService";

  //
  final ErrorLoggingApiService _errorLoggingApiService =
      ErrorLoggingApiService();

  Future<bool> saveUserPaymentAndTrackInfo({
    context,
    required double paymentAmount,
    required String paymentMethod,
    required String paymentState,
    required String trackId,
  }) async {
    try {
      // get user id
      String uid = await helper.getUserId();

      // save payment
      String paymentUrl = "$kinPaymentUrl/payment/save-payment-info/";
      var paymentBody = jsonEncode(
        {
          "userId": uid,
          "payment_amount": paymentAmount,
          "payment_method": paymentMethod,
          "payment_state": paymentState,
        },
      );

      Response paymentResponse = await post(
        Uri.parse(paymentUrl),
        body: paymentBody,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
      );

      if (paymentResponse.statusCode == 201) {
        var body = json.decode(paymentResponse.body);
        String payId = body['id'].toString();

        var trackBody = jsonEncode({
          "userId": uid,
          "payment_id": payId,
          "trackId": trackId,
          "track_price_amount": paymentAmount,
          "isPurchased": true
        });

        Response trackResponse = await post(
          Uri.parse("$kinPaymentUrl/payment/purchased-tracks/"),
          body: trackBody,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
          },
        );

        if (trackResponse.statusCode == 201) {
          return true;
        }

        return false;
      }
    } catch (e) {
      _errorLoggingApiService.logErrorToServer(
        fileName: fileName,
        functionName: "saveUserPaymentInfo",
        errorInfo: e.toString(),
        className: className,
      );
    }
    return false;
  }

  retryFuture(future, delay) {
    Future.delayed(Duration(milliseconds: delay), () {
      future();
    });
  }
}
