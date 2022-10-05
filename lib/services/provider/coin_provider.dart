import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api/coin_service.dart';

class CoinProvider extends ChangeNotifier {
  int currentCoinValue = 0;
  bool isLoading = false;
  CoinApiService coinApiService = CoinApiService();

  Future<String> getCoinBalance() async {
    isLoading = true;
    currentCoinValue = await coinApiService.getRemainingGift();

    isLoading = false;
    notifyListeners();
    return currentCoinValue.toString();
  }

  Future<String> buyCoin(int paymentAmount, String paymentMethod) async {
    isLoading = true;

    bool result = await coinApiService.buyGift(paymentAmount, paymentMethod);

    if (result == true) {
      currentCoinValue += paymentAmount;
    }

    isLoading = false;
    notifyListeners();
    return currentCoinValue.toString();
  }

  Future<String> transferCoin(int valueTransferred, String artistId) async {
    isLoading = true;

    bool result = await coinApiService.giveGift(valueTransferred, artistId);

    if (result == true) {
      currentCoinValue -= valueTransferred;
    }

    isLoading = false;
    notifyListeners();
    return currentCoinValue.toString();
  }
}
