import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/Trainer.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:pokimon/screens/combat/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import '../../utils/secrets.dart' as SECRETS;
import './utils/utils.dart';
import 'package:http/http.dart' as http;
import '../../themes/provider/themes_provider.dart';

class CombatMainPage extends StatelessWidget {
  const CombatMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      color: (context.read<ColorSchemeProvider>().isDark == true)
          ? Colors.black
          : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
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
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5.0)),
            child: InkWell(
              onTap: () async {
                String name = "Manoriega", // getUserName();
                    enemyName = CombatUtils().getEnemyName();
                List<Pokemon> team = await getUserTeam();
                List<Pokemon> enemyTeam =
                    await getRandomTeam(team.length, team[0].level);
                List<Item> backpack = await getBackPack();
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

  getUserTeam() async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        docsRef = await queryUser.get(),
        listIds = docsRef.data()?["pokemons"];

    var queryPokemons =
        await FirebaseFirestore.instance.collection("pokemon_users").get();

    var myTeamPokemons = queryPokemons.docs
        .where(
            (doc) => listIds.contains(doc.id) && doc.data()["onTeam"] == true)
        .map((doc) => doc.data().cast<String, dynamic>())
        .toList();
    List<Pokemon> myTeam = [];
    for (var i = 0; i < myTeamPokemons.length; i++) {
      var pokemonUri =
          Uri.parse(SECRETS.APIBASE + "pokemon/" + myTeamPokemons[i]["name"]);
      var pokemonResponse = await http.get(pokemonUri);
      Map<String, dynamic> pokemonJSON = jsonDecode(pokemonResponse.body);
      var speciesUri = Uri.parse(
          SECRETS.APIBASE + "pokemon-species/" + myTeamPokemons[i]["name"]);
      var speciesResponse = await http.get(speciesUri);
      Map<String, dynamic> speciesJSON = jsonDecode(speciesResponse.body);
      var firstAttackJSON = await getMove(myTeamPokemons[i]["firstAttack"]!),
          secondAttackJSON = await getMove(myTeamPokemons[i]["secondAttack"]!);
      Move firstAttack = Move(firstAttackJSON),
          secondAttack = Move(secondAttackJSON);
      myTeam.add(Pokemon(pokemonJSON, speciesJSON, myTeamPokemons[i]["level"],
          firstAttack, secondAttack));
    }
    print(myTeam[0].firstAttack);
    print(myTeam[0].secondAttack);
    return myTeam;
  }

  getBackPack() async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        docsRef = await queryUser.get(),
        listIds = docsRef.data()?["items"];
    List<Item> backpack = [];
    List myItems = [];
    for (var i = 0; i < listIds.length; i++) {
      var item = await FirebaseFirestore.instance
          .collection("pocket_items")
          .doc(listIds[i])
          .get();
      myItems.add(item.data());
    }
    for (var i = 0; i < myItems.length; i++) {
      Map<String, dynamic> item = myItems[i];
      backpack.add(Item(item["name"], item["effectValue"], item["type"],
          item["imageUrl"], item["description"]));
    }
    return backpack;
  }

  getRandomTeam(int length, int level) async {
    List<Pokemon> randomTeam = [];
    for (var i = 0; i < length; i++) {
      Pokemon pokemon = await CombatUtils().getRandomPokemon(level);
      randomTeam.add(pokemon);
      print(pokemon.firstAttack);
      print(pokemon.secondAttack);
    }
    return randomTeam;
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
