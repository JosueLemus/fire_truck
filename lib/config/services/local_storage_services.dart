import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  static Future<void> saveLocalData(String data, KeyTypes key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key.name, data);
  }

  static Future<String?> getLocalData(KeyTypes key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.name);
  }

  static Future<void> saveArrayList(
      List<String> arrayString, KeyTypes key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> serializedList =
        arrayString.map((element) => element.toString()).toList();
    prefs.setStringList(key.name, serializedList);
  }

  static Future<List<String>> getArrayList(KeyTypes key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? serializedList = prefs.getStringList(key.name);
    if (serializedList != null) {
      return serializedList;
    } else {
      return [];
    }
  }

  static Future removeData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

enum KeyTypes { userToken }
