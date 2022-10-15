import 'package:flutter/material.dart';
import 'package:pokimon/screens/catch/catch_page.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:pokimon/screens/garden/garden_page.dart';
import 'package:pokimon/screens/settings/settings_page.dart';
import 'package:pokimon/screens/team/team_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome!"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                  "Pokimon Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35),
                ),
                navigationButton(context, const CombatPage(), "Combat"),
                navigationButton(context, const CatchPage(), "Catch"),
                navigationButton(context, const TeamPage(), "Team"),
                navigationButton(context, const GardenPage(), "Garden"),
                navigationButton(context, const SettingsPage(), "Settings"),
              ],
            ),
          ),
        ));
  }

  Widget navigationButton(BuildContext context, Widget screen, String label) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: MaterialButton(
        color: Theme.of(context).buttonTheme.colorScheme?.primary,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => screen));
        },
        child: Text(label),
      ),
    );
  }
}
