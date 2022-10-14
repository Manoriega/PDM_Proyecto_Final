import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorSchemeProvider with ChangeNotifier {
  ThemeMode currentThemeMode = ThemeMode.light;
  FlexSchemeData currentFlexSchemeData = FlexColor.mandyRed;
  bool isDark = false;
  ThemeMode get getCurrentThemeMode => currentThemeMode;
  FlexSchemeData get getCurrentFlexSchemeData => currentFlexSchemeData;
  bool get getIsDark => isDark;

  void changeCurrentTheme(FlexSchemeData flexSchemeData, bool notify) {
    currentFlexSchemeData = flexSchemeData;
    if (notify) notifyListeners();
  }

  void switchMode(ThemeMode themeMode, bool notify) {
    currentThemeMode = themeMode;
    isDark = currentThemeMode == ThemeMode.light ? false : true;
    if (notify) notifyListeners();
  }
}
