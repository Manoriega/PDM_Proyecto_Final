import 'package:hive/hive.dart';
import 'package:pokimon/models/themes/theme.dart';

class Boxes {
  static Box<ThemeHive> getThemeBox() => Hive.box<ThemeHive>('theme');
}
