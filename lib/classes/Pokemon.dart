import 'package:flutter/material.dart';
import 'package:pokimon/classes/Move.dart';

class Pokemon {
  late String name;
  late String species;
  late String description;
  late String type;
  late String height;
  late String weight;
  late String imageurl;
  late String backImage;
  late Move firstAttack;
  late Move secondAttack;
  late int hp;
  late int currentHP;
  late int attack;
  late int defense;
  late int specialAttack;
  late int specialDefense;
  late int speed;
  late int level;
  late Color pokemoncolor;

  Pokemon(Map<String, dynamic> pokemonJson, Map<String, dynamic> speciesJson,
      this.level, this.firstAttack, this.secondAttack) {
    name = speciesJson['names'][6]["name"];
    species = speciesJson['genera'][7]["genus"];
    description = speciesJson["flavor_text_entries"][4]["flavor_text"];
    type = pokemonJson['types'][0]["type"]['name'][0].toUpperCase() +
        pokemonJson['types'][0]["type"]['name'].substring(1).toLowerCase();
    imageurl = pokemonJson['sprites']["front_default"];
    backImage = pokemonJson['sprites']["back_default"];
    hp = pokemonJson['stats'][0]["base_stat"];
    attack = pokemonJson['stats'][1]["base_stat"];
    defense = pokemonJson['stats'][2]["base_stat"];
    specialAttack = pokemonJson['stats'][3]["base_stat"];
    specialDefense = pokemonJson['stats'][4]["base_stat"];
    speed = pokemonJson['stats'][5]["base_stat"];
    pokemoncolor = getColorByType(type);
    currentHP = pokemonJson['stats'][0]["base_stat"];
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name. $species. $type. $imageurl. $hp. $attack. $defense. $specialAttack. $specialDefense. $speed. $pokemoncolor";
  }

  Color getColorByType(String type) {
    switch (type) {
      case "Normal":
        return Color.fromARGB(255, 221, 204, 170);
      case "Fighting":
        return Color.fromARGB(255, 255, 106, 106);
      case "Flying":
        return Color.fromARGB(255, 186, 170, 255);
      case "Water":
        return Color.fromARGB(255, 176, 226, 255);
      case "Bug":
        return Color.fromARGB(255, 153, 204, 51);
      case "Dragon":
        return Color.fromARGB(255, 171, 130, 255);
      case "Electric":
        return Colors.yellow;
      case "Ghost":
        return Color.fromARGB(255, 119, 136, 153);
      case "Fire":
        return Color.fromARGB(255, 255, 127, 0);
      case "Ice":
        return Color.fromARGB(255, 173, 216, 230);
      case "Grass":
        return Color.fromARGB(255, 153, 255, 102);
      case "Psychic":
        return Color.fromARGB(255, 255, 181, 197);
      case "Rock":
        return Color.fromARGB(255, 205, 133, 63);
      case "Ground":
        return Color.fromARGB(255, 222, 184, 135);
      case "Poison":
        return Color.fromARGB(255, 204, 136, 187);
    }
    return Color.fromARGB(255, 221, 204, 170);
  }
}
