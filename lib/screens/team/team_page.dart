import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/components/PokemonWidget.dart';
import 'package:pokimon/screens/team/bloc/team_bloc.dart';

import '../../themes/provider/themes_provider.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<Pokemon> Pokemonlist = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Team",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: BlocConsumer<TeamBloc, TeamState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is TeamSucceedState) {
              return pokemonView(state.myTeam);
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
          isInTeam: true,
        ));
      }),
    );
  }
}
