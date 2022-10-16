import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/Pokemon.dart';

class PokemonDetails extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetails({super.key, required this.pokemon});

  @override
  State<PokemonDetails> createState() => _MyAppState();
}

class _MyAppState extends State<PokemonDetails> {
  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[
      Tab(text: 'Info'),
      Tab(text: 'Stats'),
    ];
    late MaterialColor PKcolor = widget.pokemon.pokemoncolor as MaterialColor;
    List<Widget> _views = [
      Container(
        color: Colors.white,
        height: 50,
        margin: EdgeInsets.all(1),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Species ",
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(" ${widget.pokemon.species}",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              children: [
                Text("Height  ",
                    textAlign: TextAlign.left,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${widget.pokemon.height}  ",
                    textAlign: TextAlign.left, style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              children: [
                Text(
                  "Weight  ",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.pokemon.weight}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        color: Colors.white,
        height: 50,
        margin: EdgeInsets.all(1),
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'HP  ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.pokemon.HP}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'ATTACK  ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.pokemon.Attack}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Defense  ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.pokemon.defense}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Speed  ',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '${widget.pokemon.Speed}',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 250,
                      child: Positioned.fill(
                          child: Image.asset(
                        '${widget.pokemon.imageurl}',
                        fit: BoxFit.fill,
                      )),
                    ),
                  ),
                  Material(
                    color: PKcolor[300],
                    child: TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      tabs: tabs,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: _views,
                    ),
                  ),
                  Row(
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
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  )
                ],
              )),
        );
      }),
    );
  }
}
