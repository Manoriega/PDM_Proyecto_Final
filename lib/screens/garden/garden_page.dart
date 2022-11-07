import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/components/PokemonWidget.dart';

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  List<Pokemon> Pokemonlist = [];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(Pokemonlist.length, (index) {
        return (PokemonWidget(aPokemon: Pokemonlist[index]));
      }),
    );
  }
}
