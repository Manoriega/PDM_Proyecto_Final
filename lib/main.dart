import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pokimon/screens/begginer/beginner_page.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/controllers/current_user.dart';
import 'package:pokimon/models/themes/theme.dart';
import 'package:pokimon/screens/begginer/bloc/beginner_pokemons_bloc.dart';
import 'package:pokimon/screens/catch/bloc/catch_pokemon_bloc.dart';
import 'package:pokimon/screens/combat/bloc/combat_bloc.dart';
import 'package:pokimon/screens/garden/bloc/pokemon_garden_bloc.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/LoginPage2.dart';
import 'package:pokimon/screens/login/bloc/auth_bloc.dart';
import 'package:pokimon/screens/pokemon-detail/TeamProvider.dart';
import 'package:pokimon/screens/settings/bloc/user_bloc.dart';
import 'package:pokimon/screens/signin/signin_page.dart';
import 'package:pokimon/screens/team/bloc/team_bloc.dart';
import 'package:pokimon/themes/app_themes.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import 'package:pokimon/utils/TextStyles.dart';
import '../../../utils/secrets.dart' as SECRETS;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ThemeHiveAdapter());
  await Hive.openBox<ThemeHive>('theme');

  await Firebase.initializeApp();

  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => BeginnerPokemonsBloc(),
        ),
        BlocProvider(
          create: (context) => CatchPokemonBloc(),
        ),
        BlocProvider(create: (context) => TeamBloc()),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(create: (context) => CombatBloc()),
        BlocProvider(create: (context) => PokemonGardenBloc()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ColorSchemeProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(
            create: (context) => TeamProvider(),
          )
        ],
        child: const MyApp(),
      )));
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
              appBarBackground: theme.currentFlexSchemeData.light.appBarColor,
              textTheme: PokemonTheme),
          darkTheme: FlexThemeData.dark(
              colors: theme.currentFlexSchemeData.dark,
              appBarBackground: theme.currentFlexSchemeData.dark.appBarColor,
              textTheme: PokemonTheme),
          themeMode: theme.currentThemeMode,
          home: FirebaseAuth.instance.currentUser == null
              ? LoginPage2()
              : HomePage());
    }));
  }
}
