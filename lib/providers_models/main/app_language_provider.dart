import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguageProvider extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  AppLanguageProvider() {
    fetchLocale();
  }

  Locale get appLocal => _appLocale;

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      return Null;
    }
    _appLocale = Locale(prefs.getString('language_code')!);
    return Null;
  }

  void changeLanguage(String languageCode) async {
    var prefs = await SharedPreferences.getInstance();
    _appLocale = Locale(languageCode);
    await prefs.setString('language_code', languageCode);
    notifyListeners();
  }
}
