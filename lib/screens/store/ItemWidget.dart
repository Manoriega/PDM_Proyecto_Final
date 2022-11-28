import 'package:flutter/material.dart';
import 'package:pokimon/screens/store/StoreItem.dart';

class ItemWidget extends StatelessWidget {
  final StoreItem storeItem;
  const ItemWidget({super.key, required this.storeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Image.network(
            "${storeItem.itemImage}",
            height: 200,
            width: 200,
            fit: BoxFit.fill,
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.primary,
            trailing: Image.asset(
              'assets/PokeBallPixelArt.png',
              height: 50,
              width: 50,
            ),
            title: Text(
              "${storeItem.name}",
              style: Theme.of(context).textTheme.headline2,
            ),
          )
        ],
      ),
    );
  }
}
