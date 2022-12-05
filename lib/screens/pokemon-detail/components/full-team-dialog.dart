import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';

class FullTeamDialog extends StatelessWidget {
  const FullTeamDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You can't add this pokemon."),
      content:
          Text("Your team has already 4 pokemons. Leave one in the garden."),
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