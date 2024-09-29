import 'package:flutter/material.dart';
import 'package:lukafulu/theme/Theme_preferences.dart';
import 'package:lukafulu/theme/theme.dart';



class ThemeProvider extends ChangeNotifier{
  ThemePreferences themePreferences = ThemePreferences();
  bool currentTheme = false;

  ThemeData get themeData {
    if(currentTheme){
      return  darkMode;
    }else{
      return lightMode;
    }
  }

  changeTheme(bool value) async {
    await themePreferences.setTheme(value);
    currentTheme = value;
    notifyListeners();
  }

  initializeTheme() async{
    currentTheme =await themePreferences.getTheme();
    notifyListeners();
  }


}


