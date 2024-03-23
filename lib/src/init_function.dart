import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class InitFunction {
  initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  setPrefValue(String key, dynamic value) async {
    if (value.runtimeType == bool) {
      await prefs!.setBool(key, value);
    } else if (value.runtimeType == String) {
      await prefs!.setString(key, value);
    } else if (value.runtimeType == int) {
      await prefs!.setInt(key, value);
    }
  }

  getPrefValue(String key, dynamic value) {
    if (value.runtimeType == bool) {
      prefs!.getBool(key) ?? false;
    } else if (value.runtimeType == String) {
      prefs!.getString(key) ?? '';
    } else if (value.runtimeType == int) {
      prefs!.getInt(key) ?? -1;
    }
  }
}
