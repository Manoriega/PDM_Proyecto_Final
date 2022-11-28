import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokimon/screens/pokemon-detail/TeamProvider.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import 'package:provider/provider.dart';

import '../../classes/Pokemon.dart';

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetails({super.key, required this.pokemon});

  @override
  State<PokemonDetails> createState() => _MyAppState();
}

class _MyAppState extends State<PokemonDetails> {
  Future<bool> searchPokemonInDB(String pokemon) async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        docsRef = await queryUser.get(),
        listIds = docsRef.data()?["pokemons"];

    var queryPokemons =
        await FirebaseFirestore.instance.collection("pokemon_users").get();

    var myTeamPokemons = queryPokemons.docs
        .where(
            (doc) => listIds.contains(doc.id) && doc.data()["onTeam"] == true)
        .map((doc) => doc.data().cast<String, dynamic>())
        .toList();
    print(myTeamPokemons);
    List<String> pokemonNames = [];
    for (int i = 0; i < myTeamPokemons.length; i++) {
      pokemonNames.add(myTeamPokemons[i]["name"]);
    }

    return myTeamPokemons.contains(widget.pokemon.name);
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(
        text: 'Info',
      ),
      Tab(text: 'Stats'),
    ];
    late MaterialColor PKcolor = widget.pokemon.pokemoncolor as MaterialColor;
    List<Widget> _views = [
      Container(
        color: (context.read<ColorSchemeProvider>().isDark == true)
            ? Colors.black
            : Colors.white,
        height: 50,
        margin: EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PokemonRow(context, "Species  ", " ${widget.pokemon.species}"),
            Text(widget.pokemon.description,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ),
      ),
      Container(
        color: (context.read<ColorSchemeProvider>().isDark == true)
            ? Colors.black
            : Colors.white,
        height: 50,
        margin: EdgeInsets.all(1),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PokemonRow(context, "HP ", "${widget.pokemon.hp}"),
            PokemonRow(context, "ATTACK ", "${widget.pokemon.attack}"),
            PokemonRow(context, "DEFENSE ", "${widget.pokemon.defense}"),
            PokemonRow(
                context, "SPECIAL ATTACK ", "${widget.pokemon.specialAttack}"),
            PokemonRow(context, "SPECIAL DEFENSE ",
                "${widget.pokemon.specialDefense}"),
            PokemonRow(context, "SPEED ", "${widget.pokemon.speed}")
          ],
        ),
      ),
    ];
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return SafeArea(
          child: Scaffold(
              backgroundColor: widget.pokemon.pokemoncolor,
              body: Column(
                children: [
                  ListTile(
                    tileColor: PKcolor[700],
                    leading: Text(
                      "${widget.pokemon.name}",
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 250,
                      child: Positioned.fill(
                          child: Image.network(
                        '${widget.pokemon.imageurl}',
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  Material(
                    color: PKcolor[300],
                    child: TabBar(
                      labelColor:
                          (context.read<ColorSchemeProvider>().isDark == true)
                              ? Colors.white
                              : Colors.black,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: (context.read<ColorSchemeProvider>().isDark ==
                                  true)
                              ? Colors.black
                              : Colors.white),
                      tabs: tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _views,
                    ),
                  ),
                  FutureBuilder<bool?>(
                    future: searchPokemonInDB(widget.pokemon.name),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return CreateTeamButton(context);
                      } else if (snapshot.hasData && snapshot.data == false) {
                        return RemoveFromTeamButton(context);
                      }
                      return Container(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator());
                    },
                  )
                ],
              )),
        );
      }),
    );
  }

  Row CreateTeamButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
              onPressed: () {},
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
    );
  }

  Row RemoveFromTeamButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
              onPressed: () {},
              icon: Image.asset(
                'assets/PokeBallPixelArt.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
              label: Text(
                "Remove from team",
                style: Theme.of(context).textTheme.subtitle2,
              )),
        ),
      ],
    );
  }

  Row PokemonRow(BuildContext context, String Stat, String actualstat) {
    return Row(
      children: [
        Text(Stat,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle2),
        Text(actualstat,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle1),
      ],
    );
  }

  Future<void> removeFromTeam() async {
    var pokemonInDB = await FirebaseFirestore.instance
        .collection('pokemon_users')
        .where('name', isEqualTo: widget.pokemon.name)
        .where('onTeam', isEqualTo: true)
        .get();
  }
}
