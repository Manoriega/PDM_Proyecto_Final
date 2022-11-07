import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/combat_page.dart';

class ChooseCombat extends StatelessWidget {
  const ChooseCombat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CombatPage(),
              ));
            },
            child: Text("Player vs IA"),
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
