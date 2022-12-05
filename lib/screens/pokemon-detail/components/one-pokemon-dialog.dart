import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';

class OnePokemonDialog extends StatelessWidget {
  const OnePokemonDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You can't remove this pokemon."),
      content: Text(
          "You only have one left pokemon in your team. You must have at least one in your team to be a pokemon trainer"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Accept")),
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