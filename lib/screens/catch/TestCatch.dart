import 'package:flutter/material.dart';
import 'package:pokimon/components/PokemonWidget.dart';

import '../../classes/Pokemon.dart';

class TestCatch extends StatelessWidget {
  final Pokemon pokemon;
  const TestCatch({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PokemonWidget(aPokemon: pokemon),
    );
  }
}
