import 'package:shared_preferences/shared_preferences.dart';

class sharedPref {
  static Future<bool> setLoggedAccount(String account) async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("remembered account");
      pref.setString("remembered account", account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> deleteLoggedAccount() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("remembered account");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<String> getLoggedAccount() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("remembered account") ?? "";
    return result;
  }
}
