import 'package:flutter/material.dart';
import 'package:pokimon/screens/store/ItemWidget.dart';
import 'package:pokimon/screens/store/StoreItem.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    StoreItem testItem = StoreItem(
        "A spray-type medicine for wounds. It restores the HP of one Pokémon by just 20 points.",
        20,
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/potion.png",
        "Potion");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Store",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Center(
        child: ItemWidget(storeItem: testItem),
      ),
    );
  }
}
