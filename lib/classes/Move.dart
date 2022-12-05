import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../utils/secrets.dart' as SECRETS;

class Move {
  late int power, accuracy;
  late String name, type, category, description;
  late Color moveColor;

  Move(Map<String, dynamic> moveJson) {
    power = moveJson["power"];
    accuracy = moveJson["accuracy"];
    name = firstCharacterCap(moveJson["name"]);
    type = firstCharacterCap(moveJson["type"]["name"]);
    description = moveJson["flavor_text_entries"][1]["flavor_text"];
    category = moveJson["damage_class"]["name"];
    moveColor = getColorByType(type);
  }
  @override
  String toString() {
    return "$name. Power: $power. Accuracy: $accuracy. Type: $type. Category: $category";
  }
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

getMove(String moveName) async {
  var url = "${SECRETS.APIBASE}move/$moveName",
      movementResponse = await http.get(Uri.parse(url)),
      movement = jsonDecode(movementResponse.body);
  return movement;
}

getSpecialMove(String pokemonName) async {
  switch (pokemonName) {
    case "oddish":
      return await getMove('vine-whip');
    case "charmander":
      return await getMove('ember');
    case "dratini":
      return await getMove("dragon-tail");
    case "pikachu":
      return await getMove("thunder-shock");
    case "mankey":
      return await getMove("karate-chop");
    case "seel":
      return await getMove("water-gun");
    case "grimer":
      return await getMove("sludge");
    case "drowzee":
      return await getMove("confusion");
    case "cubone":
      return await getMove("bone-club");
    case "snorlax":
      return await getMove("headbutt");
    case "paras":
      return await getMove("leech-life");
    case "geodude":
      return await getMove("rock-throw");
    case "gastly":
      return await getMove("shadow-ball");
    case "swinub":
      return await getMove("powder-snow");
    default:
      return await getMove("tackle");
  }
}

String firstCharacterCap(String str) {
  String s = str.substring(0, 1).toUpperCase() + str.substring(1);
  return s;
}
