// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokimon/classes/Move.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/Trainer.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/combat/bloc/combat_bloc.dart';
import 'package:pokimon/screens/combat/components/player_lost_dialog.dart';
import 'package:pokimon/screens/combat/components/player_won_dialog.dart';
import 'package:pokimon/screens/combat/components/run_away_dialog.dart';
import 'package:pokimon/screens/combat/components/wild_pokemon_catch.dart';
import 'package:pokimon/screens/combat/components/wild_pokemon_flee.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import './utils/utils.dart' as CombatUtils;

class CombatPage extends StatefulWidget {
  final Trainer player, enemy;
  final int isCatch;
  final String backgroundUrl;
  const CombatPage(
      {super.key,
      required this.player,
      required this.enemy,
      required this.isCatch,
      required this.backgroundUrl});

  @override
  State<CombatPage> createState() => _CombatPageState();
}

class _CombatPageState extends State<CombatPage> {
  var menuIndex = 0,
      detailedItem,
      currentMessage = "",
      detailedMove,
      detailedPokemon,
      numAttack;

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var screenHeight = MediaQuery.of(context).size.height - statusBar;
    var screenWidth = MediaQuery.of(context).size.width - statusBar;
    return WillPopScope(
      onWillPop: () async {
        if (widget.isCatch == 0) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text("You can't run away from a combat")));
        } else {
          ShowCustomDialog(context, RunAwayDialog());
        }
        return false;
      },
      child: BlocConsumer<CombatBloc, CombatState>(
        listener: (context, state) {
          if (state is WaitingState) {
            setState(() {
              menuIndex = 5;
              currentMessage = state.msg;
            });
          } else if (state is PlayerChangePokemonState) {
            setState(() {
              widget.player.active = state.changedP;
            });
          } else if (state is EnemyTurnState) {
            BlocProvider.of<CombatBloc>(context)
                .add(EnemyTurnEvent(widget.enemy, 0, widget.player));
          } else if (state is PlayerActivePokemonDiesState) {
            setState(() {
              menuIndex = 6;
            });
          } else if (state is EnemyActivePokemonDiesState) {
            setState(() {
              widget.enemy.active = getNextEnemyPokemon(widget.enemy.team);
            });
          } else if (state is PlayerWinState) {
            setState(() {
              menuIndex = 0;
            });
            if (widget.isCatch == 1) {
              ShowCustomDialog(
                  context, WildPokemonCatch(pokemon: widget.enemy.active));
            } else {
              ShowCustomDialog(
                  context,
                  PlayerWonDialog(
                    enemyName: widget.enemy.name,
                  ));
            }
            // Testing
          } else if (state is PlayerLooseState) {
            setState(() {
              menuIndex = 0;
            });
            if (widget.isCatch == 1) {
              ShowCustomDialog(
                  context, WildPokemonFlee(pokemon: widget.enemy.active));
            } else {
              ShowCustomDialog(
                  context, PlayerLostDialog(enemyName: widget.enemy.name));
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: SizedBox(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.network(
                    widget.backgroundUrl,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: statusBar,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: screenHeight * .14,
                          width: screenWidth * .8,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color:
                                  (context.read<ColorSchemeProvider>().isDark ==
                                          true)
                                      ? Color.fromARGB(255, 43, 43, 43)
                                      : Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.enemy.active.name),
                                ],
                              ),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: getCurrentHP(
                                    widget.enemy.active.currentHP,
                                    widget.enemy.active.hp),
                                progressColor: getProgressColor(
                                  getCurrentHP(widget.enemy.active.currentHP,
                                      widget.enemy.active.hp),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          height: screenHeight * .2,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.bottomRight,
                          child: Image.network(
                            widget.enemy.active.imageurl,
                            width: MediaQuery.of(context).size.width / 2,
                            fit: BoxFit.contain,
                          )),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: screenHeight * .14,
                          width: screenWidth * .8,
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color:
                                  (context.read<ColorSchemeProvider>().isDark ==
                                          true)
                                      ? Color.fromARGB(255, 43, 43, 43)
                                      : Colors.white,
                              border: Border.all(
                                  color: Theme.of(context).disabledColor,
                                  width: 4),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.player.active.name),
                                  Text("Lv${widget.player.active.level}"),
                                ],
                              ),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: getCurrentHP(
                                    widget.player.active.currentHP,
                                    widget.player.active.hp),
                                progressColor: getProgressColor(
                                  getCurrentHP(widget.player.active.currentHP,
                                      widget.player.active.hp),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "${widget.player.active.currentHP}/${widget.player.active.hp}",
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * .2,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.bottomLeft,
                        child: Image.network(
                          widget.player.active.backImage,
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        height: screenHeight * .32,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color:
                                (context.read<ColorSchemeProvider>().isDark ==
                                        true)
                                    ? Color.fromARGB(255, 43, 43, 43)
                                    : Color(0xFFC7C7C7),
                            border: Border.all(
                                color: Theme.of(context).disabledColor,
                                width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            )),
                        padding: const EdgeInsets.all(10.0),
                        child: GetMenuWidget(menuIndex, state),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget MainMenu() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        actionButton("Fight", Colors.red[300], () {
          setState(() {
            menuIndex = 1;
          });
        }),
        actionButton("Items", Colors.green[300], () {
          setState(() {
            menuIndex = 3;
          });
        }),
        actionButton("Team", Colors.brown[300], () {
          setState(() {
            menuIndex = 2;
          });
        }),
        actionButton("Run away", Colors.deepOrange[300], () {
          if (widget.isCatch == 0) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text("You can't run away from a combat.")));
          } else {
            ShowCustomDialog(context, RunAwayDialog());
          }
        }),
      ],
      childAspectRatio: (2),
    );
  }

  Widget messageMenu(String msg, CombatState state) {
    return GestureDetector(
      onTap: (() {
        if (state is WaitingState) {
          if (state.state == 0) {
            BlocProvider.of<CombatBloc>(context)
                .add(EnemyTurnEvent(widget.enemy, 0, widget.player));
          } else {
            setState(() {
              menuIndex = 0;
            });
          }
        }
      }),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            color: (context.read<ColorSchemeProvider>().isDark == true)
                ? Colors.black
                : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(msg), Text("Press to continue...")],
        ),
      ),
    );
  }

  Widget FightMenu() {
    Move firstAttack = widget.player.active.firstAttack,
        secondAttack = widget.player.active.secondAttack;
    return GridView.count(
      crossAxisCount: 2,
      children: [
        actionButton(firstCharacterCap(firstAttack.name), firstAttack.moveColor,
            () {
          BlocProvider.of<CombatBloc>(context)
              .add(PlayerAttackEvent(0, widget.player, widget.enemy));
          setState(() {
            menuIndex = 7;
          });
        }),
        actionButton(
            firstCharacterCap(secondAttack.name), secondAttack.moveColor, () {
          BlocProvider.of<CombatBloc>(context)
              .add(PlayerAttackEvent(1, widget.player, widget.enemy));
          setState(() {
            menuIndex = 7;
          });
        }),
        Text(""),
        actionButton("Back", Colors.deepOrange[300], () {
          setState(() {
            menuIndex = 0;
          });
        }),
      ],
      childAspectRatio: (2),
    );
  }

  Widget SelectItem() {
    List<Widget> options = [];
    for (var i = 0; i < widget.player.backpack.length; i++) {
      Item item = widget.player.backpack[i];
      Color? typeC = item.type == 0 ? Colors.green[300] : Colors.red[300];
      options.add(actionButton(item.name, typeC, () {
        setState(() {
          detailedItem = item;
          menuIndex = 4;
        });
      }));
    }
    if (options.length % 2 == 0) options.add(Text(""));
    options.add(actionButton("Back", Colors.deepOrange[300], () {
      setState(() {
        menuIndex = 0;
      });
    }));
    return GridView.count(
      crossAxisCount: 2,
      children: options,
      childAspectRatio: (2),
    );
  }

  Widget itemDetail(Item item) {
    Color? itemC = item.type == 0 ? Colors.green[300] : Colors.red[200];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(item.image, scale: 0.5),
            Text(item.name, style: Theme.of(context).textTheme.headline1)
          ],
        ),
        Text(
          item.description,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actionButton("Use", itemC, () {
              BlocProvider.of<CombatBloc>(context).add(PlayerUseItemEvent(
                  item, widget.player.active, widget.player));
              setState(() {
                menuIndex = 7;
              });
            }),
            actionButton("Back", Colors.deepOrange[300], () {
              setState(() {
                menuIndex = 3;
              });
            })
          ],
        )
      ],
    );
  }

  Widget ChooseTeam() {
    List<Widget> options = [];
    for (var i = 0; i < widget.player.team.length; i++) {
      Pokemon pokemon = widget.player.team[i];
      Color? colorP = pokemon.pokemoncolor;
      if (pokemon != widget.player.active) {
        options.add(actionButton(pokemon.name, colorP, () {
          setState(() {
            detailedPokemon = pokemon;
            menuIndex = 9;
          });
        }));
      }
    }
    if (options.length % 2 == 0) options.add(Text(""));
    options.add(actionButton("Back", Colors.deepOrange[300], () {
      setState(() {
        menuIndex = 0;
      });
    }));
    return GridView.count(
      crossAxisCount: 2,
      children: options,
      childAspectRatio: (2),
    );
  }

  Widget pokemonDetail(Pokemon pokemon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(pokemon.name, style: Theme.of(context).textTheme.headline1),
            Text("HP: ${pokemon.currentHP}/${pokemon.hp}",
                style: Theme.of(context).textTheme.headline2),
          ],
        ),
        Image.network(pokemon.imageurl, scale: 0.84),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            actionButton("Change", pokemon.pokemoncolor, () {
              BlocProvider.of<CombatBloc>(context)
                  .add(PlayerChangePokemonEvent(pokemon));
              setState(() {
                menuIndex = 7;
              });
              setState(() {
                menuIndex = 7;
              });
            }),
            actionButton("Back", Colors.deepOrange[300], () {
              setState(() {
                menuIndex = 2;
              });
            })
          ],
        )
      ],
    );
  }

  Container actionButton(String label, Color? color, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: MaterialButton(
        color: color,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  String firstCharacterCap(String str) {
    String s = str.substring(0, 1).toUpperCase() + str.substring(1);
    return s;
  }

  double getCurrentHP(int current, int total) {
    double currentH = current.toDouble(), totalH = total.toDouble();
    return (currentH / totalH);
  }

  GetMenuWidget(int menuIndex, CombatState state) {
    switch (menuIndex) {
      case 0:
        return MainMenu();
      case 1:
        return FightMenu();
      case 2:
        return ChooseTeam();
      case 3:
        return SelectItem();
      case 4:
        return itemDetail(detailedItem);
      case 5:
        return messageMenu(currentMessage, state);
      case 6:
        return ChangePokemon();
      case 7:
        return LoadingMenu();
      case 9:
        return pokemonDetail(detailedPokemon);
    }
  }

  Color getProgressColor(double currentHP) {
    if (currentHP > 0.8)
      return Colors.green;
    else if (currentHP > 0.5)
      return Colors.yellow;
    else if (currentHP > 0.25)
      return Colors.orange;
    else
      return Colors.red;
  }

  ChangePokemon() {
    List<Widget> options = [];
    for (var i = 0; i < widget.player.team.length; i++) {
      Pokemon pokemon = widget.player.team[i];
      Color? colorP = pokemon.pokemoncolor;
      if (pokemon != widget.player.active && pokemon.currentHP > 0) {
        options.add(actionButton(pokemon.name, colorP, () {
          setState(() {
            widget.player.active = pokemon;
            menuIndex = 0;
          });
          BlocProvider.of<CombatBloc>(context).add(SetPlayerTurnEvent());
        }));
      }
    }
    return GridView.count(
      crossAxisCount: 2,
      children: options,
      childAspectRatio: (2),
    );
  }

  Pokemon getNextEnemyPokemon(List<Pokemon> team) {
    Pokemon p = team[0];
    for (var pokemon in team) {
      if (pokemon.currentHP > 0) {
        p = pokemon;
        break;
      }
    }
    return p;
  }

  Widget LoadingMenu() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
