import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SPUtil {
  static SPUtil _spUtil;
  static SharedPreferences _prefs;
  static Lock _lock = new Lock();

  SPUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<SPUtil> getInstance() async {
    if (null == _spUtil) {
      await _lock.synchronized(() async {
        if (null == _spUtil) {
          var spUtil = SPUtil._();
          await spUtil._init();
          _spUtil = spUtil;
        }
      });
    }
    return _spUtil;
  }

  static String getString(String key) {
    if (_prefs == null) return null;
    return _prefs.getString(key);
  }

  static Future<bool> putString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value);
  }

  static bool getBool(String key) {
    if (_prefs == null) return null;
    return _prefs.getBool(key);
  }

  static Future<bool> putBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs.setBool(key, value);
  }

  static int getInt(String key) {
    if (_prefs == null) return null;
    return _prefs.getInt(key);
  }

  static Future<bool> putInt(String key, int value) {
    if (_prefs == null) return null;
    return _prefs.setInt(key, value);
  }

  static double getDouble(String key) {
    if (_prefs == null) return null;
    return _prefs.getDouble(key);
  }

  static Future<bool> putDouble(String key, double value) {
    if (_prefs == null) return null;
    return _prefs.setDouble(key, value);
  }

  static List<String> getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<bool> putStringList(String key, List<String> value) {
    if (_prefs == null) return null;
    return _prefs.setStringList(key, value);
  }

  static dynamic getDynamic(String key) {
    if (_prefs == null) return null;
    return _prefs.get(key);
  }

  static Set<String> getKeys() {
    if (_prefs == null) return null;
    return _prefs.getKeys();
  }

  static Future<bool> remove(String key) {
    if (_prefs == null) return null;
    return _prefs.remove(key);
  }

  static Future<bool> clear() {
    if (_prefs == null) return null;
    return _prefs.clear();
  }

  static void putObject<T>(String key, Object value) {
    switch (T) {
      case int:
        putInt(key, value);
        break;
      case double:
        putDouble(key, value);
        break;
      case bool:
        putBool(key, value);
        break;
      case String:
        putString(key, value);
        break;
      case List:
        putStringList(key, value);
        break;
      default:
        putString(key, value == null ? "" : json.encode(value));
        break;
    }
  }
}

