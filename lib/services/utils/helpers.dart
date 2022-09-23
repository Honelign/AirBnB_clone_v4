import 'package:shared_preferences/shared_preferences.dart';

class HelperUtils {
  Future getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("id") ?? "";

    return uid;
  }
}
