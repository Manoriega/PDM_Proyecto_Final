import 'package:flutter/material.dart';
import 'package:pokimon/screens/settings/settings_page.dart';

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
          title: Text("Welcome!"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Pokimon Game",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35),
                ),
                navigationButton(context, SettingsPage(), "Combat"),
                navigationButton(context, SettingsPage(), "Catch"),
                navigationButton(context, SettingsPage(), "Team"),
                navigationButton(context, SettingsPage(), "Garden"),
                navigationButton(context, SettingsPage(), "Settings"),
              ],
            ),
          ),
        ));
  }

  Widget navigationButton(BuildContext context, Widget screen, String label) {
    return Container(
      margin: EdgeInsets.all(8.0),
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
