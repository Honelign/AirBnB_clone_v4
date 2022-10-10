import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperUtils {
  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("id") ?? "";

    return uid;
  }

  checkConnection(status) {
    if (status == ConnectivityStatus.wifi ||
        status == ConnectivityStatus.cellular) {
      return true;
    }
    return false;
  }
}
