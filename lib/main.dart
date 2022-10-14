import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokimon/models/themes/theme.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';
import 'package:pokimon/themes/app_themes.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ThemeHiveAdapter());
  await Hive.openBox<ThemeHive>('theme');

  runApp(ChangeNotifierProvider(
      create: (context) => ColorSchemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeHive? th = ThemeHive().getTheme();
    if (th == null) {
      ThemeHive().addTheme(
          0,
          context.read<ColorSchemeProvider>().getCurrentThemeMode ==
              Brightness.dark);
    } else {
      var itemAppTheme = AppTheme.values[th.flexSchemeData];
      context.read<ColorSchemeProvider>().changeCurrentTheme(
          appThemeData[itemAppTheme] ?? FlexColor.green, false);
      context
          .read<ColorSchemeProvider>()
          .switchMode(th.isDark ? ThemeMode.dark : ThemeMode.light, false);
    }

    return Consumer<ColorSchemeProvider>(builder: ((context, theme, child) {
      return MaterialApp(
          title: 'Material App',
          theme: FlexThemeData.light(
              colors: theme.currentFlexSchemeData.light,
              appBarBackground: theme.currentFlexSchemeData.light.appBarColor),
          darkTheme: FlexThemeData.dark(
              colors: theme.currentFlexSchemeData.dark,
              appBarBackground: theme.currentFlexSchemeData.dark.appBarColor),
          themeMode: theme.currentThemeMode,
          home: const LoginPage());
    }));
  }
}
