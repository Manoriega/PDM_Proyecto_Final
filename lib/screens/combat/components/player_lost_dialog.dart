import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/combat/utils/utils.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';

class PlayerLostDialog extends StatelessWidget {
  final String enemyName;
  final List<Item> currentListItem;
  const PlayerLostDialog(
      {super.key, required this.enemyName, required this.currentListItem});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You've lost the combat"),
      content: Text("You've been defeated by ${enemyName}!"),
      actions: [
        TextButton(
            onPressed: () async {
              await CombatUtils().registerCombat(1, enemyName);
              CombatUtils().updateBackpack(currentListItem);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
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