import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/pokemon-detail/TeamProvider.dart';
import 'package:pokimon/screens/pokemon-detail/components/full-team-dialog.dart';
import 'package:pokimon/screens/pokemon-detail/components/one-pokemon-dialog.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import 'package:provider/provider.dart';

import '../../classes/Pokemon.dart';

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;
  bool isInTeam;
  PokemonDetails({super.key, required this.pokemon, required this.isInTeam});

  @override
  State<PokemonDetails> createState() => _MyAppState();
}

class _MyAppState extends State<PokemonDetails> {
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(
        text: 'Info',
      ),
      Tab(text: 'Stats'),
    ];
    List<Widget> _views = [
      Container(
        color: (context.read<ColorSchemeProvider>().isDark == true)
            ? Colors.black
            : Colors.white,
        height: 50,
        margin: EdgeInsets.all(1),
        child: ListView(
          shrinkWrap: true,
          children: [
            PokemonRow(context, "Species  ", " ${widget.pokemon.species}"),
            PokemonRow(context, "Type  ", " ${widget.pokemon.type}"),
            PokemonRow(context, "First attack  ",
                " ${widget.pokemon.firstAttack.name}"),
            PokemonRow(context, "Second attack ",
                " ${widget.pokemon.secondAttack.name}"),
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
            PokemonStatRow(context, "HP ", widget.pokemon.hp),
            PokemonStatRow(context, "ATTACK ", widget.pokemon.attack),
            PokemonStatRow(context, "DEFENSE ", widget.pokemon.defense),
            PokemonStatRow(
                context, "SPECIAL ATTACK ", widget.pokemon.specialAttack),
            PokemonStatRow(
                context, "SPECIAL DEFENSE ", widget.pokemon.specialDefense),
            PokemonStatRow(context, "SPEED ", widget.pokemon.speed)
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
                    tileColor: widget.pokemon.pokemoncolor,
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
                    color: widget.pokemon.pokemoncolor,
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
                  widget.isInTeam
                      ? RemoveFromTeamButton(context)
                      : CreateTeamButton(context)
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
              onPressed: () {
                AddToTeam();
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
    );
  }

  Row RemoveFromTeamButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
              onPressed: () {
                removeFromTeam();
              },
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

  Row PokemonStatRow(BuildContext context, String Stat, int actualstat) {
    double actualvalue = actualstat / 100;
    return Row(
      children: [
        Text(Stat,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.subtitle2),
        Container(
          height: 20,
          width: 140,
          child: LinearProgressIndicator(
            color: widget.pokemon.pokemoncolor,
            value: actualvalue,
          ),
        )
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

  Future<void> AddToTeam() async {
    try {
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
      if (myTeamPokemons.length < 4) {
        var thePokemonID = queryPokemons.docs.where((doc) =>
            listIds.contains(doc.id) &&
            doc.data()["onTeam"] == false &&
            doc.data()["name"] == "${widget.pokemon.name.toLowerCase()}");
        CollectionReference pokemons =
            await FirebaseFirestore.instance.collection("pokemon_users");
        pokemons.doc(thePokemonID.first.id).update({'onTeam': true});
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => route is HomePage);
      } else {
        ShowCustomDialog(context, FullTeamDialog());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFromTeam() async {
    try {
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
      if (myTeamPokemons.length == 1) {
        ShowCustomDialog(context, OnePokemonDialog());
      } else {
        var thePokemonID = queryPokemons.docs.where((doc) =>
            listIds.contains(doc.id) &&
            doc.data()["onTeam"] == true &&
            doc.data()["name"] == "${widget.pokemon.name.toLowerCase()}");
        CollectionReference pokemons =
            await FirebaseFirestore.instance.collection("pokemon_users");
        pokemons.doc(thePokemonID.first.id).update({'onTeam': false});
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => route is HomePage);
      }
    } catch (e) {
      print(e);
    }
  }
}
