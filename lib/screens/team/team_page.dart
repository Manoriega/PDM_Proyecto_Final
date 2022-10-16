import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/components/PokemonWidget.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<Pokemon> Pokemonlist = [
    Pokemon("Pikachu", "Mouse", "Electric", "0.4m", "6.0 kg",
        "assets/spr_frlg_025.png", 35, 55, 40, 90, Colors.amber),
    Pokemon("Charizard", "Flame", "Fire", "1.7m", "90.5 kg",
        "assets/spr_frlg_006.png", 78, 84, 78, 100, Colors.deepOrange),
    Pokemon("Vaporeon", "Bubble Jet", "water", "1.0m", "29.0 kg",
        "assets/spr_frlg_134.png", 130, 65, 60, 65, Colors.blue)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Team",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(Pokemonlist.length, (index) {
            return (PokemonWidget(aPokemon: Pokemonlist[index]));
          }),
        ));
  }
}
