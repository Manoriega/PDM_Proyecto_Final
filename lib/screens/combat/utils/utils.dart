import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/combat/utils/random_backgrounds.dart';
import 'package:pokimon/screens/combat/utils/random_enemy_names.dart';
import 'package:pokimon/screens/combat/utils/random_pokemon.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/pokemon-detail/components/full-team-dialog.dart';
import '../../../utils/secrets.dart' as SECRETS;

final _random = Random();

int randInRange(int min, int max) => min + _random.nextInt(max - min);

class CombatUtils {
  getMoveColor(String moveName) async {
    var url = SECRETS.APIBASE + "move/${moveName}",
        movementResponse = await http.get(Uri.parse(url)),
        movement = jsonDecode(movementResponse.body),
        type = movement["type"]["name"];
    switch (type) {
      case "normal":
        return Colors.grey[400];
      case "fire":
        return Colors.red[300];
      default:
    }
  }

  getMoveType(String moveName) async {
    var url = "${SECRETS.APIBASE}move/$moveName",
        movementResponse = await http.get(Uri.parse(url)),
        movement = jsonDecode(movementResponse.body),
        type = movement["type"]["name"];
    return type;
  }

  getMoveCategory(String moveName) async {
    var url = "${SECRETS.APIBASE}move/$moveName",
        movementResponse = await http.get(Uri.parse(url)),
        movement = jsonDecode(movementResponse.body),
        category = movement["damage_class"]["name"];
    return category;
  }

  getMovePotential(String moveName) async {
    var url = "${SECRETS.APIBASE}move/$moveName",
        movementResponse = await http.get(Uri.parse(url)),
        movement = jsonDecode(movementResponse.body),
        potential = movement["power"];
    return potential;
  }

  getMoveAccuracy(String moveName) async {
    var url = "${SECRETS.APIBASE}move/$moveName",
        movementResponse = await http.get(Uri.parse(url)),
        movement = jsonDecode(movementResponse.body),
        accuracy = movement["accuracy"];
    return accuracy;
  }

  getRandomPokemon(int level) async {
    var i = randInRange(0, randomPokemons.length);
    var randPokemon = randomPokemons[i];
    var pokemonUri =
        Uri.parse(SECRETS.APIBASE + "pokemon/${randPokemon["name"]}");
    var pokemonResponse = await http.get(pokemonUri);
    Map<String, dynamic> pokemonJSON = jsonDecode(pokemonResponse.body);
    var speciesUri =
        Uri.parse(SECRETS.APIBASE + "pokemon-species/${randPokemon["name"]}");
    var speciesResponse = await http.get(speciesUri);
    Map<String, dynamic> speciesJSON = jsonDecode(speciesResponse.body);
    var firstAttackJSON = await getMove(randPokemon["firstAttack"]!),
        secondAttackJSON = await getMove(randPokemon["secondAttack"]!);
    Move firstAttack = Move(firstAttackJSON),
        secondAttack = Move(secondAttackJSON);
    return Pokemon(pokemonJSON, speciesJSON, level, firstAttack, secondAttack);
  }

  getRandomBackground() {
    var i = randInRange(0, randomBackgrounds.length);
    return randomBackgrounds[i];
  }

  CatchPokemon(Pokemon pokemon) async {
    try {
      var queryUser = FirebaseFirestore.instance
          .collection("pocket_users")
          .doc(FirebaseAuth.instance.currentUser!.uid);
      var newPokemon = {
        "name": pokemon.name.toLowerCase(),
        "firstAttack": pokemon.firstAttack.name.toLowerCase(),
        "secondAttack": pokemon.secondAttack.name.toLowerCase(),
        "onTeam": false,
        "level": pokemon.level
      };
      var queryPokemons =
          FirebaseFirestore.instance.collection("pokemon_users").doc();
      await queryPokemons.set(newPokemon);
      queryUser.update({
        "pokemons": FieldValue.arrayUnion([queryPokemons.id])
      });
    } catch (e) {}
  }

  getEnemyName() {
    var i = randInRange(0, randomEnemies.length);
    return randomEnemies[i];
  }

  registerCombat(int type, String enemyName) async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        userRef = await queryUser.get(),
        username = userRef.data()?["username"];
    var newBattle = {"Winner": "", "createdAt": DateTime.now()};
    if (type == 0) {
      newBattle["Winner"] = FirebaseAuth.instance.currentUser!.uid;
    } else {
      newBattle["Winner"] = enemyName;
    }
    var queryBattles =
        FirebaseFirestore.instance.collection("pocket_battles").doc();
    await queryBattles.set(newBattle);
    queryUser.update({
      "battles": FieldValue.arrayUnion([queryBattles.id])
    });
  }

  getEffectiveness(String attackType, String attackedType) {
    switch (attackType) {
      case "Normal":
        if (attackedType == 'Ghost' || attackedType == 'Rock') {
          return 0.5;
        } else {
          return 1;
        }
      case "Fighting":
        if (attackedType == "Ice" ||
            attackedType == "Normal" ||
            attackedType == "Rock") {
          return 2;
        } else if (attackedType == "Bug" ||
            attackedType == "Psychic" ||
            attackedType == "Poison" ||
            attackedType == "Flying") {
          return 0.5;
        } else {
          return 1;
        }
      case "Flying":
        if (attackedType == "Bug" ||
            attackedType == "Fighting" ||
            attackedType == "Grass") {
          return 2;
        } else if (attackedType == "Electric" || attackedType == "Rock") {
          return 0.5;
        } else {
          return 1;
        }
      case "Poison":
        if (attackedType == "Bug" || attackedType == "Grass") {
          return 2;
        } else if (attackedType == "Ghost" ||
            attackedType == "Rock" ||
            attackedType == "Ground" ||
            attackedType == "Poison") {
          return 0.5;
        } else {
          return 1;
        }
      case "Ground":
        if (attackedType == "Electric" ||
            attackedType == "Fire" ||
            attackedType == "Rock" ||
            attackedType == "Poison") {
          return 2;
        } else if (attackedType == "Bug" || attackedType == "Grass") {
          return 0.5;
        } else {
          return 1;
        }
      case "Rock":
        if (attackedType == "Bug" ||
            attackedType == "Fire" ||
            attackedType == "Ice" ||
            attackedType == "Flying") {
          return 2;
        } else if (attackedType == "Fighting" || attackedType == "Ground") {
          return 0.5;
        } else {
          return 1;
        }
      case "Bug":
        if (attackedType == "Grass" ||
            attackedType == "Psychic" ||
            attackedType == "Poison") {
          return 2;
        } else if (attackedType == "Fire" ||
            attackedType == "Fighting" ||
            attackedType == "Flying") {
          return 0.5;
        } else {
          return 1;
        }
      case "Ghost":
        if (attackedType == "Ghost") {
          return 2;
        } else {
          return 1;
        }
      case "Fire":
        if (attackedType == "Bug" ||
            attackedType == "Ice" ||
            attackedType == "Grass") {
          return 2;
        } else if (attackedType == "Water" ||
            attackedType == "Dragon" ||
            attackedType == "Fire" ||
            attackedType == "Rock") {
          return 0.5;
        } else {
          return 1;
        }
      case "Water":
        if (attackedType == "Fire" ||
            attackedType == "Rock" ||
            attackedType == "Ground") {
          return 2;
        } else if (attackedType == "Water" ||
            attackedType == "Dragon" ||
            attackedType == "Grass") {
          return 0.5;
        } else {
          return 1;
        }
      case "Grass":
        if (attackedType == "Water" ||
            attackedType == "Rock" ||
            attackedType == "Ground") {
          return 2;
        } else if (attackedType == "Bug" ||
            attackedType == "Dragon" ||
            attackedType == "Fire" ||
            attackedType == "Grass" ||
            attackedType == "Poison" ||
            attackedType == "Flying") {
          return 0.5;
        } else {
          return 1;
        }
      case "Electric":
        if (attackedType == "Water" || attackedType == "Flying") {
          return 2;
        } else if (attackedType == "Dragon" ||
            attackedType == "Electric" ||
            attackedType == "Grass") {
          return 0.5;
        } else {
          return 1;
        }
      case "Psychic":
        if (attackedType == "Fighting" || attackedType == "Poison") {
          return 2;
        } else if (attackedType == "Psychic") {
          return 0.5;
        } else {
          return 1;
        }
      case "Ice":
        if (attackedType == "Dragon" ||
            attackedType == "Grass" ||
            attackedType == "Ground" ||
            attackedType == "Flying") {
          return 2;
        } else if (attackedType == "Water" || attackedType == "Ice") {
          return 0.5;
        } else {
          return 1;
        }
      case "Dragon":
        if (attackedType == "Dragon") {
          return 2;
        } else {
          return 1;
        }
      default:
        return 1;
    }
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

  getUserName() async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        userRef = await queryUser.get(),
        username = userRef.data()?["username"];
    return username;
  }
}
