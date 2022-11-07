import 'package:flutter/material.dart';
import '../classes/Pokemon.dart';
import '../screens/pokemon-detail/PokemonDetails.dart';

class PokemonWidget extends StatelessWidget {
  final Pokemon aPokemon;

  const PokemonWidget({super.key, required this.aPokemon});

  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PokemonDetails(pokemon: this.aPokemon)));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 120,
          width: 120,
          margin: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8)),
            child: Stack(
              children: [
                Positioned.fill(
                    child: Image.network(
                  "${aPokemon.imageurl}",
                  fit: BoxFit.contain,
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/PokeBallPixelArt.png',
                              height: 25,
                              width: 25,
                            ),
                            Text(
                              "${aPokemon.name}",
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
