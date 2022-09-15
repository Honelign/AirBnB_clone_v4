import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinApiService {
  // error logging service
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  // get the coin balance of a user
  Future getRemainingGift() async {
    // get user id
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String id = prefs.getString("id") ?? "";

    try {
      Response response =
          await get(Uri.parse("$kinPaymentUrl/gift/save-payment-info/$id"));

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        return body['payment_amount'];
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "coin_service.dart",
        className: "CoinApiService",
        functionName: "getRemainingGift",
        errorInfo: e.toString(),
      );
    }
    return 0;
  }

  // buy / increase coin of  a user
  Future buyGift(int paymentAmount, String paymentMethod) async {
    try {
      // get user id
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString("id") ?? "";

      // request url & body
      String uri = "$kinPaymentUrl/gift/save-payment-info/";
      Map<String, dynamic> requestBody = {
        "userId": id.toString(),
        "payment_amount": paymentAmount.toString(),
        "payment_method": paymentMethod,
      };

      if (id != "") {
        Response postResponse = await post(Uri.parse(uri), body: requestBody);

        // user already has payment info
        if (postResponse.statusCode == 400) {
          Response putResponse =
              await put(Uri.parse("$uri$id/"), body: requestBody);

          // put successful
          if (putResponse.statusCode == 200) {
            return true;
          }
          // put failed
          else {
            return false;
          }
        }
        // post is successful
        else if (postResponse.statusCode == 200) {
          return true;
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "coin_service.dart",
        className: "CoinApiService",
        functionName: "buyGift",
        errorInfo: e.toString(),
      );
    }

    return false;
  }

  // transfer coin to artist
  Future giveGift(int giftAmount, String artistId) async {
    try {
      // get user id
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String id = prefs.getString("id") ?? "";

      // request url & body
      String uri = "$kinPaymentUrl/gift/give-gift/";
      Map<String, dynamic> requestBody = {
        "userId": id.toString(),
        "gift_amount": giftAmount.toString(),
        "ArtistId": artistId.toString(),
      };

      Response response = await post(Uri.parse(uri), body: requestBody);

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "coin_service.dart",
        className: "CoinApiService",
        functionName: "giveGift",
        errorInfo: e.toString(),
      );

      return false;
    }
  }
}
