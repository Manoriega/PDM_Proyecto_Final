import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/classes/BeginnerPokemon.dart';
import 'package:pokimon/screens/begginer/bloc/beginner_pokemons_bloc.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../themes/provider/themes_provider.dart';
import '../home/home_page.dart';

class BegginnerPage extends StatefulWidget {
  const BegginnerPage({super.key});

  @override
  State<BegginnerPage> createState() => _BegginnerPageState();
}

class _BegginnerPageState extends State<BegginnerPage> {
  List<BeginnerPokemon> beginnerPokemons = [
    BeginnerPokemon(
        "tackle",
        "ember",
        true,
        5,
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/emerald/4.png",
        "charmander",
        Color.fromARGB(255, 255, 127, 0)),
    BeginnerPokemon(
        "tackle",
        "water-gun",
        true,
        5,
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/7.png",
        "squirtle",
        Color.fromARGB(255, 176, 226, 255)),
    BeginnerPokemon(
        "tackle",
        "vine-whip",
        true,
        5,
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-iii/firered-leafgreen/1.png",
        "bulbasaur",
        Color.fromARGB(255, 153, 255, 102))
  ];
  int _focusedIndex = 0;

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    //horizontal
    return Container(
      width: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            child: Container(
              width: 180,
              height: 180,
              margin: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(
                      "${beginnerPokemons[index].image}",
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    )),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                          decoration: BoxDecoration(
                              color: beginnerPokemons[index].color,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8))),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/PokeBallPixelArt.png',
                                  height: 25,
                                  width: 25,
                                ),
                                Text(
                                  "${beginnerPokemons[index].name}",
                                  style: Theme.of(context).textTheme.subtitle2,
                                  overflow: TextOverflow.clip,
                                )
                              ])),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BeginnerPokemonsBloc, BeginnerPokemonsState>(
      listener: (context, state) {
        if (state is BeginerPokemonsSucess) {
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => HomePage(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "WELCOME TO POKIMON!",
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
            Center(
              child: Text(
                "In order to become a pokemon trainer \nyou'll receive one pokemon.",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
            Divider(),
            Center(
              child: Text("Please choose your first pokemon to continue.",
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 6,
              child: ScrollSnapList(
                onItemFocus: _onItemFocus,
                itemSize: 250,
                itemBuilder: _buildListItem,
                itemCount: beginnerPokemons.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        BlocProvider.of<BeginnerPokemonsBloc>(context).add(
                            AddBeginnerPokemonsEvent(
                                pokemon: beginnerPokemons[_focusedIndex]));
                      },
                      icon: Image.asset(
                        'assets/PokeBallPixelArt.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      label: Text(
                        "Add to team",
                        style: Theme.of(context).textTheme.subtitle2,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
