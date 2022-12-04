import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/combat/utils/utils.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';

class PlayerLostDialog extends StatelessWidget {
  final String enemyName;
  const PlayerLostDialog({super.key, required this.enemyName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Has perdido el combate"),
      content: Text("Has sido derrotado por ${enemyName}!"),
      actions: [
        TextButton(
            onPressed: () async {
              await CombatUtils().registerCombat(1, enemyName);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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