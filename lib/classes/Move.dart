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
      return Colors.grey;
    case "Fighting":
      return Colors.brown[700]!;
    case "Flying":
      return Colors.blue[700]!;
    case "Water":
      return Colors.blue;
    case "Bug":
      return Colors.lightGreen[200]!;
    case "Dragon":
      return Colors.deepPurple[400]!;
    case "Electric":
      return Colors.yellow;
    case "Ghost":
      return Colors.purple[900]!;
    case "Fire":
      return Colors.red;
    case "Ice":
      return Colors.blue[100]!;
    case "Grass":
      return Colors.green;
    case "Psychic":
      return Colors.pink;
    case "Rock":
      return Colors.brown[200]!;
    case "Ground":
      return Colors.yellow[100]!;
    case "Poison":
      return Colors.purple[600]!;
  }
  return Colors.grey;
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
    case "dratini":
      return await getMove("dragon-tail");
    case "pikachu":
      return await getMove("thunder-shock");
    case "mankey":
      return await getMove("karate-chop");
    default:
      return await getMove("tacke");
  }
}

String firstCharacterCap(String str) {
  String s = str.substring(0, 1).toUpperCase() + str.substring(1);
  return s;
}
