import 'package:flutter/material.dart';
import 'package:pokimon/screens/combat/combat_page.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import '../../themes/provider/themes_provider.dart';

class CombatMainPage extends StatelessWidget {
  const CombatMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      color: (context.read<ColorSchemeProvider>().isDark == true)
          ? Colors.black
          : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5), topRight: Radius.circular(5.0)),
            child: InkWell(
              onTap: (() {}),
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                foregroundDecoration: RotatedCornerDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    geometry: const BadgeGeometry(
                        width: 150,
                        height: 150,
                        cornerRadius: 5,
                        alignment: BadgeAlignment.topLeft),
                    textSpan: TextSpan(
                        text: "vs\n Player",
                        style: Theme.of(context).textTheme.headline1)),
                child: Image.asset(
                  'assets/PokemonPVP.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5.0)),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CombatPage(),
                ));
              },
              child: Container(
                color: Theme.of(context).colorScheme.primary,
                foregroundDecoration: RotatedCornerDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    geometry: const BadgeGeometry(
                      width: 150,
                      height: 150,
                      cornerRadius: 5,
                    ),
                    textSpan: TextSpan(
                        text: "vs\n Trainer",
                        style: Theme.of(context).textTheme.headline1)),
                child: Image.asset(
                  'assets/PokemonTeamCharizard.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopRectangle extends CustomClipper<Path> {
  var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(0, size.width / 2);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
