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
      title: Text("No puedes agregar este pokemon"),
      content: Text(
          "Tu equipo ya cuenta con 4 pokemons. Para agregar este pokemon debes remover uno de tu equipo"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Aceptar")),
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