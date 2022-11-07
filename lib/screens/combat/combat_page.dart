import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pokimon/screens/combat/bloc/combat_bloc.dart';

class CombatPage extends StatefulWidget {
  const CombatPage({super.key});

  @override
  State<CombatPage> createState() => _CombatPageState();
}

class _CombatPageState extends State<CombatPage> {
  var menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var screenHeight = MediaQuery.of(context).size.height - statusBar;
    var screenWidth = MediaQuery.of(context).size.width - statusBar;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text("No puedes huir de un combate")));
        return false;
      },
      child: BlocConsumer<CombatBloc, CombatState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: SizedBox(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.network(
                    "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/134205305/original/e88fbf766161b5d8143af92cc0e4a5700907787e/draw-pixel-art-sprites-and-backgrounds.png",
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
                              color: Colors.white,
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
                                  Text("Charmander"),
                                  Text("Lv5"),
                                ],
                              ),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: 0.9,
                                progressColor: Colors.green,
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
                            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png",
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
                              color: Colors.white,
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
                                  Text("Bulbasaur"),
                                  Text("Lv5"),
                                ],
                              ),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: 0.45,
                                progressColor: Colors.orange,
                                backgroundColor: Colors.grey,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "8/20",
                                    textAlign: TextAlign.end,
                                  ),
                                ],
                              ),
                              LinearPercentIndicator(
                                lineHeight: 8.0,
                                percent: 0.45,
                                progressColor: Colors.blue,
                                backgroundColor: Colors.grey,
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
                          "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
                          width: MediaQuery.of(context).size.width / 2,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Container(
                        height: screenHeight * .32,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Color(0xFFC7C7C7),
                            border: Border.all(
                                color: Theme.of(context).disabledColor,
                                width: 2),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            )),
                        padding: const EdgeInsets.all(10.0),
                        child: GetMenuWidget(menuIndex),
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
        actionButton("Pelear", Colors.red[300], () {
          setState(() {
            menuIndex = 1;
          });
        }),
        actionButton("Mochila", Colors.green[300], () {
          setState(() {
            menuIndex = 3;
          });
        }),
        actionButton("Equipo", Colors.brown[300], () {
          setState(() {
            menuIndex = 2;
          });
        }),
        actionButton("Huir", Colors.deepOrange[300], () {
          Navigator.of(context).pop();
        }),
      ],
      childAspectRatio: (2),
    );
  }

  Widget FightMenu() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        actionButton("Ataque Normal", Colors.red[300], () {}),
        actionButton("Ataque Especial", Colors.green[300], () {}),
        Text(""),
        actionButton("Atrás", Colors.deepOrange[300], () {
          setState(() {
            menuIndex = 0;
          });
        }),
      ],
      childAspectRatio: (2),
    );
  }

  Widget SelectItem() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        actionButton("Item 1", Colors.red[300], () {}),
        actionButton("Item 2", Colors.green[300], () {}),
        actionButton("Item 3", Colors.orange[100], () {}),
        actionButton("Item 4", Colors.blue[300], () {}),
        Text(""),
        actionButton("Atrás", Colors.deepOrange[300], () {
          setState(() {
            menuIndex = 0;
          });
        }),
      ],
      childAspectRatio: (2),
    );
  }

  Widget ChooseTeam() {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        actionButton("Pokemon 1", Colors.red[300], () {}),
        actionButton("Pokemon 2", Colors.green[300], () {}),
        actionButton("Pokemon 3", Colors.orange[100], () {}),
        actionButton("Pokemon 4", Colors.blue[300], () {}),
        Text(""),
        actionButton("Atrás", Colors.deepOrange[300], () {
          setState(() {
            menuIndex = 0;
          });
        }),
      ],
      childAspectRatio: (2),
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

  GetMenuWidget(int menuIndex) {
    switch (menuIndex) {
      case 0:
        return MainMenu();
      case 1:
        return FightMenu();
      case 2:
        return ChooseTeam();
      case 3:
        return SelectItem();
    }
  }
}
