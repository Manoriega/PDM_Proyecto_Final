import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:pokimon/controllers/boxes.dart';

part 'theme.g.dart';

@HiveType(typeId: 0)
class ThemeHive extends HiveObject {
  @HiveField(0)
  late int flexSchemeData;

  @HiveField(1)
  late bool isDark;

  Future<void> addTheme(int flexSchemeData, bool isDark) async {
    final theme = ThemeHive()
      ..flexSchemeData = flexSchemeData
      ..isDark = isDark;
    final box = Boxes.getThemeBox();
    if (box.length == 1)
      box.putAt(0, theme);
    else
      box.add(theme);
  }

  ThemeHive? getTheme() {
    final box = Boxes.getThemeBox();
    if (box.length < 1) {
      return null;
    }
    return box.getAt(0);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Id: $flexSchemeData\nIs dark? $isDark";
  }
}
