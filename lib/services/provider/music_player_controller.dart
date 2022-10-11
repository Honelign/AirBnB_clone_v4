import 'package:flutter/cupertino.dart';

class MusicPlayerController extends ChangeNotifier {
  bool isProcessingPlay = false;

  Future setIsProcessingPlayToTrue() async {
    isProcessingPlay = true;
    notifyListeners();
  }

  Future setIsProcessingPlayToFalse() async {
    isProcessingPlay = false;
    notifyListeners();
  }
}
