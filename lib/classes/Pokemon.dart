import 'package:flutter/material.dart';

class Pokemon {
  late String name;
  late String species;
  late String description;
  late String type;
  late String height;
  late String weight;
  late String imageurl;
  late String backImage;
  late int hp;
  late int attack;
  late int defense;
  late int specialAttack;
  late int specialDefense;
  late int speed;
  late int level;
  late Color pokemoncolor;

  Pokemon(Map<String, dynamic> pokemonJson, Map<String, dynamic> speciesJson,
      this.level) {
    name = speciesJson['names'][6]["name"];
    species = speciesJson['genera'][5]["genus"];
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
  }

  @override
  String toString() {
    // TODO: implement toString
    return "$name. $species. $type. $imageurl. $hp. $attack. $defense. $specialAttack. $specialDefense. $speed. $pokemoncolor";
  }

  Color getColorByType(String type) {
    switch (type) {
      case "Fire":
        return Colors.red;
      case "Grass":
        return Colors.green;
    }
    return Colors.grey;
  }
}
