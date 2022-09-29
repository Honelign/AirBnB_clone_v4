import 'package:flutter/cupertino.dart';

class MultiSelectProvider extends ChangeNotifier {
  bool isLoading = false;

  List<String> selectModeSelectedMusicIds = [];

  // set select mode on or off

  Future<bool> cancelAllSelection() async {
    isLoading = true;

    selectModeSelectedMusicIds = [];
    isLoading = false;
    notifyListeners();
    return true;
  }

  // check if id is in selected list
  Future<bool> checkIfMusicInSelectedList({required String musicId}) async {
    // if empty
    if (selectModeSelectedMusicIds.isEmpty) {
      return false;
    }

    List<String> filteredIds = selectModeSelectedMusicIds
        .where((element) => element.toString() == musicId.toString())
        .toList();

    // if filter empty
    if (filteredIds.isEmpty) {
      return false;
    }

    return true;
  }

  // add to select list
  Future<bool> addMusicToSelectedList({required String musicId}) async {
    isLoading = true;

    if (selectModeSelectedMusicIds.isEmpty) {
      selectModeSelectedMusicIds.add(musicId.toString());
      isLoading = false;
      notifyListeners();
      return true;
    }

    bool isInList = await checkIfMusicInSelectedList(musicId: musicId);
    if (isInList == false) {
      selectModeSelectedMusicIds.add(musicId.toString());
    }
    // remove from list
    else {
      selectModeSelectedMusicIds.remove(musicId.toString());
    }

    isLoading = false;
    notifyListeners();
    return true;
  }
}
