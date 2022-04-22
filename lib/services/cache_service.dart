import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static Future setSelectedLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('selectedLanguage', lang);
  }

  static Future getSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('selectedLanguage'));
  }

  static Future<bool> setAllData(Map data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allData', json.encode(data));
  }

  static Future<Map> getAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? info = prefs.getString('allData');
    try {
      return json.decode(info!) as Map;
    } catch (err) {
      return Future(() => {});
    }
  }

  static Future<bool> deleteAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('allData', json.encode({}));
  }

  static Future setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('fcmtoken', token);
  }

  static Future getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('fcmtoken'));
  }

  // save setTheme on storage
  static Future<bool> setTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('setTheme', isDark);
  }

  // get setTheme from storage
  static Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getBool('setTheme')!);
  }

  // save font on storage
  static Future setFont(String isFont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('font', isFont);
  }

  // get font from storage
  static Future getFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getString('font'));
  }

  static Future<bool> setImageData(String postId, List<File>? images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> imageData = images!.map((item) => item.path).toList();
    return prefs.setStringList(postId, imageData);
  }

  static Future getImageData(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return Future(() => prefs.getStringList(id));
  }
}
