import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/screens/garden/bloc/pokemon_garden_bloc.dart';
import 'package:pokimon/screens/garden/garden_page.dart';
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
            Positioned(
              child: ClipPath(
                clipper: CustomClipPath(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    BlocProvider.of<PokemonGardenBloc>(context)
                        .add(ResetAllMyPokemonsEvent());
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GardenPage()));
                    BlocProvider.of<PokemonGardenBloc>(context)
                        .add(getAllMyPokemonsEvent());
                  },
                  child: Container(
                    width: 390,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 350, right: 150),
                          child: ImageIcon(
                            AssetImage(
                              'assets/new.png',
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            size: 170,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 150),
                          child: Text(
                            "GARDEN",
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 7,
              child: ClipPath(
                clipper: TriangleMask(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    BlocProvider.of<TeamBloc>(context).add(ResetMyTeamEvent());
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TeamPage()));
                    BlocProvider.of<TeamBloc>(context).add(GetMyTeamEvent());
                  },
                  child: Container(
                      width: 400,
                      height: 670,
                      color: Theme.of(context).colorScheme.secondary,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "TEAM",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 80),
                          child: Image.asset(
                            'assets/teampokemons.png',
                            fit: BoxFit.fill,
                            width: 300,
                            height: 300,
                          ),
                        ),
                      ])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TriangleMask extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
