// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pokimon/screens/MainPage.dart';
import 'package:pokimon/screens/catch/CapturePage.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:pokimon/screens/garden/garden_page.dart';
import 'package:pokimon/screens/settings/settings_page.dart';
import 'package:pokimon/screens/store/store_page.dart';
import 'package:pokimon/screens/team/team_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  final _pagesNameList = ["Main Page", "Capture", "Store", "Combat"];
  final _pagesList = [MainPage(), CapturePage(), StorePage(), CombatMainPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          _pagesNameList[_currentPageIndex],
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ));
            },
            icon: Icon(
              Icons.settings,
              size: 40,
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentPageIndex,
        children: _pagesList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).colorScheme.secondary,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentPageIndex,
        onTap: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: _pagesNameList[0],
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[1],
            icon: ImageIcon(AssetImage("assets/pokemonCaptureAdd.png")),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[2],
            icon: ImageIcon(AssetImage('assets/pokeballs.png')),
          ),
          BottomNavigationBarItem(
            label: _pagesNameList[3],
            icon: ImageIcon(AssetImage('assets/pokemoncombaticon.png')),
          ),
        ],
      ),
    );
  }
}
