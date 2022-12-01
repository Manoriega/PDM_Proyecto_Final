import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';
import '../utils/utils.dart';

class PlayerWonDialog extends StatelessWidget {
  final String enemyName;
  const PlayerWonDialog({super.key, required this.enemyName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Has ganado el combate"),
      content: Text("¡Felicidades has derrotado a ${enemyName}!"),
      actions: [
        TextButton(
            onPressed: () async {
              await CombatUtils().registerCombat(0, enemyName);
              Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage(),
                  ));
            },
            child: Text("Salir")),
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