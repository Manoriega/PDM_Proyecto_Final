import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/components/PokemonWidget.dart';
import 'package:pokimon/screens/garden/bloc/pokemon_garden_bloc.dart';
import 'package:provider/provider.dart';

import '../../themes/provider/themes_provider.dart';

class GardenPage extends StatefulWidget {
  const GardenPage({super.key});

  @override
  State<GardenPage> createState() => _GardenPageState();
}

class _GardenPageState extends State<GardenPage> {
  List<Pokemon> Pokemonlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Garden",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: BlocConsumer<PokemonGardenBloc, PokemonGardenState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is GotAllPokemons) {
              return pokemonView(state.myPokemons);
            }

            return ListView.separated(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return PlayStoreShimmer(
                  isDarkMode:
                      (context.read<ColorSchemeProvider>().isDark == true)
                          ? true
                          : false,
                  hasBottomSecondLine: false,
                );
              },
              separatorBuilder: (BuildContext context, index) =>
                  const Divider(),
            );
          },
        ));
  }

  GridView pokemonView(List<Pokemon> team) {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(team.length, (index) {
        return (PokemonWidget(
          aPokemon: team[index],
          isInTeam: false,
        ));
      }),
    );
  }
}
