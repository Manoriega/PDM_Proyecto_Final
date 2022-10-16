import 'package:flutter/material.dart';

class Pokemon {
  final String? name;
  final String? species;
  final String? type;
  final String? height;
  final String? weight;
  final String? imageurl;
  final double? HP;
  final double? Attack;
  final double? defense;
  final double? Speed;
  final Color? pokemoncolor;

  Pokemon(
      this.name,
      this.species,
      this.type,
      this.height,
      this.weight,
      this.imageurl,
      this.HP,
      this.Attack,
      this.defense,
      this.Speed,
      this.pokemoncolor);
  Pokemon.fromjson(Map<String, dynamic> json)
      : name = json['pokemonname'],
        species = json['species'],
        type = json['type'],
        height = json['height'],
        weight = json['weight'],
        imageurl = json['imageurl'],
        HP = json['stats']['hp'],
        Attack = json['stats']['attack'],
        defense = json['stats']['defense'],
        Speed = json['stats']['speed'],
        pokemoncolor = Colors.grey;
}
