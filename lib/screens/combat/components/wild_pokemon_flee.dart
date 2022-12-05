import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';
import '../utils/utils.dart';

class WildPokemonFlee extends StatelessWidget {
  final Pokemon pokemon;
  final List<Item> currentListItem;
  const WildPokemonFlee(
      {super.key, required this.pokemon, required this.currentListItem});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("The wild ${pokemon.name} beat you."),
      content: Text("Maybe later you'll catch'em all."),
      actions: [
        TextButton(
            onPressed: () async {
              CombatUtils().updateBackpack(currentListItem);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()),
                  (Route<dynamic> route) => route is HomePage);
            },
            child: Text("Exit")),
      ],
    );
  }
}

/* await _signOut();
                    Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const LoginPage(),
                        )); 
                        
                        */