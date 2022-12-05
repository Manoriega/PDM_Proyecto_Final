import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/Trainer.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:pokimon/screens/combat/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import '../../utils/secrets.dart' as SECRETS;
import './utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../themes/provider/themes_provider.dart';

class CombatMainPage extends StatefulWidget {
  const CombatMainPage({super.key});

  @override
  State<CombatMainPage> createState() => _CombatMainPageState();
}

class _CombatMainPageState extends State<CombatMainPage> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return (Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text("We're preparing the combat. Please wait a moment.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline2)
        ],
      )));
    }
    return Container(
      margin: EdgeInsets.all(4),
      color: (context.read<ColorSchemeProvider>().isDark == true)
          ? Colors.black
          : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5.0)),
            child: InkWell(
              onTap: (() {}),
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                foregroundDecoration: RotatedCornerDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    geometry: const BadgeGeometry(
                        width: 150,
                        height: 150,
                        cornerRadius: 5,
                        alignment: BadgeAlignment.topLeft),
                    textSpan: TextSpan(
                        text: "vs\n Player",
                        style: Theme.of(context).textTheme.headline1)),
                child: Image.asset(
                  'assets/PokemonPVP.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ), */
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5.0)),
            child: InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                String name = await CombatUtils().getUserName(),
                    enemyName = CombatUtils().getEnemyName();
                List<Pokemon> team = await CombatUtils().getUserTeam();
                List<Pokemon> enemyTeam = await CombatUtils()
                    .getRandomTeam(team.length, team[0].level);
                List<Item> backpack = await CombatUtils().getBackPack();
                Trainer player = Trainer(name, team[0], team, backpack);
                Trainer enemy =
                    Trainer(enemyName, enemyTeam[0], enemyTeam, backpack);
                String backgroundURL = CombatUtils().getRandomBackground();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CombatPage(
                      player: player,
                      enemy: enemy,
                      isCatch: 0,
                      backgroundUrl: backgroundURL),
                ));
                setState(() {
                  isLoading = false;
                });
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                foregroundDecoration: RotatedCornerDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    geometry: const BadgeGeometry(
                      width: 150,
                      height: 150,
                      cornerRadius: 5,
                    ),
                    textSpan: TextSpan(
                        text: "vs\n Trainer",
                        style: Theme.of(context).textTheme.headline1)),
                child: Image.asset(
                  'assets/PokemonTeamCharizard.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopRectangle extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(0, size.width / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
