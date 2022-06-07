import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const String IS_LOGGED_IN = "isLoggedIn";
  static const String FIREBASE_UID = "USER_FIREBASE_UID";
  static const String USER_TOKEN = "USER_TOKEN";

  saveUserItem() {}

  void clearFavoriteItem() {}

  void clearUserItem() async {}

  Future<bool?> putString(String key, String value) async {
    return _preferences == null ? null : _preferences!.setString(key, value);
  }

  double getDouble(String key, {double defValue = 0.0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getDouble(key) ?? defValue;
  }

  List<String> getList(String key, {List<String> defValue = const []}) {
    return _preferences == null
        ? defValue
        : _preferences!.getStringList(key) ?? defValue;
  }

  String getString(String key, {String defValue = ""}) {
    return _preferences == null
        ? defValue
        : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    return _preferences == null ? null : _preferences!.setInt(key, value);
  }

  int getInt(String key, {int defValue = 0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getInt(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    return _preferences == null ? null : _preferences!.setBool(key, value);
  }

  Future<bool?> putDouble(String key, double value) async {
    return _preferences == null ? null : _preferences!.setDouble(key, value);
  }

  Future<bool?> putList(String key, List<String> value) async {
    return _preferences == null
        ? null
        : _preferences!.setStringList(key, value);
  }

  bool getBool(String key, {bool defValue = false}) {
    return _preferences == null
        ? defValue
        : _preferences!.getBool(key) ?? defValue;
  }
}
