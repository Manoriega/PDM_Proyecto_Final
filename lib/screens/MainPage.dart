import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/screens/store/store_page.dart';
import 'package:pokimon/screens/team/bloc/team_bloc.dart';
import 'package:pokimon/screens/team/team_page.dart';
import 'package:provider/provider.dart';

import '../themes/provider/themes_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.all(4),
        color: (context.read<ColorSchemeProvider>().isDark == true)
            ? Colors.black
            : Colors.white,
        child: Stack(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => StorePage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [.5, .5],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Colors.transparent, // top Right part
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 400,
                        width: 200,
                      ),
                      ImageIcon(
                        AssetImage(
                          'assets/new.png',
                        ),
                        color: Theme.of(context).colorScheme.secondary,
                        size: 150,
                      ),
                      Text(
                        "STORE",
                        style: Theme.of(context).textTheme.headline1,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  BlocProvider.of<TeamBloc>(context).add(ResetMyTeamEvent());
                  BlocProvider.of<TeamBloc>(context).add(GetMyTeamEvent());
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => TeamPage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          "TEAM",
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Stack(
                        children: [
                          Image.asset(
                            'assets/teampokemons.png',
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width,
                            height: 280,
                          )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      stops: [.5, .5],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Colors.transparent, // top Right part
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
