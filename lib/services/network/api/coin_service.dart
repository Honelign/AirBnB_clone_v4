import 'dart:convert';

import 'package:http/http.dart';
import 'package:kin_music_player_app/constants.dart';
import 'package:kin_music_player_app/services/network/api/error_logging_service.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoinApiService {
  // error logging service
  ErrorLoggingApiService errorLoggingApiService = ErrorLoggingApiService();

  // get the coin balance of a user
  Future getRemainingGift() async {
    String id = await helper.getUserId();

    try {
      Response response = await get(
          Uri.parse("$kinPaymentUrl/gift/save-gift-payment-info/$id"));

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
  Future buyGift(
      {required int paymentAmount, required String paymentMethod}) async {
    bool result = false;
    print("lookie buy gift called");
    try {
      String id = await helper.getUserId();

      // request url & body
      String uri = "$kinPaymentUrl/gift/save-gift-payment-info/";
      Map<String, dynamic> requestBody = {
        "userId": id.toString(),
        "payment_amount": paymentAmount.toString(),
        "payment_method": paymentMethod,
        "payment_state": "completed",
      };

      if (id != "") {
        Response postResponse = await post(Uri.parse(uri), body: requestBody);

        // user already has payment info
        if (postResponse.statusCode == 400) {
          Response putResponse =
              await put(Uri.parse("$uri$id/"), body: requestBody);

          // put successful
          if (putResponse.statusCode == 200) {
            result = true;
          }
          // put failed
          else {
            result = false;
          }
        }
        // post is successful
        else if (postResponse.statusCode == 200) {
          result = true;
        }
      }
    } catch (e) {
      errorLoggingApiService.logErrorToServer(
        fileName: "coin_service.dart",
        className: "CoinApiService",
        functionName: "buyGift",
        errorInfo: e.toString(),
      );
      result = false;
    }

    print("lookie buy gift called and result is $result");
    return result;
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
