import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';
import '../utils/utils.dart';

class WildPokemonCatch extends StatelessWidget {
  final Pokemon pokemon;
  const WildPokemonCatch({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You defeated the wild ${pokemon.name}"),
      content: Text("Now you can find ${pokemon.name} in your GARDEN"),
      actions: [
        TextButton(
            onPressed: () async {
              await CombatUtils().CatchPokemon(pokemon);
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