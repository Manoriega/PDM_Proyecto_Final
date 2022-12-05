import 'package:flutter/material.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/screens/store/components/buy_item_page.dart';

class ItemWidget extends StatelessWidget {
  final Item storeItem;
  const ItemWidget({super.key, required this.storeItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BuyItemPage(
                  item: storeItem,
                )));
      }),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              "${storeItem.image}",
              scale: 0.3,
            ),
            ListTile(
              tileColor: Theme.of(context).colorScheme.primary,
              trailing: Image.asset(
                'assets/PokeBallPixelArt.png',
              ),
              title: Text(
                "${storeItem.name}",
                style: Theme.of(context).textTheme.headline5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
