import 'package:flutter/material.dart';
import 'package:pokimon/classes/item.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/store/components/utils.dart';

class BuyItemPage extends StatefulWidget {
  final Item item;
  const BuyItemPage({super.key, required this.item});

  @override
  State<BuyItemPage> createState() => _BuyItemPageState();
}

class _BuyItemPageState extends State<BuyItemPage> {
  int count = 0, sum = 0;
  var loading = false;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.item.name,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              "${widget.item.image}",
              scale: 0.3,
            ),
            Text(
              widget.item.description,
              style: Theme.of(context).textTheme.headline6,
            ),
            Text(
              "Price: ${widget.item.price}",
              style: Theme.of(context).textTheme.headline6,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  child: Card(
                    elevation: 2,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "$count",
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            count++;
                            sum += widget.item.price;
                          });
                        },
                      ),
                    ),
                    Card(
                      child: IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            if (count > 0) {
                              count--;
                              sum -= widget.item.price;
                            }
                          });
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            Text(
              "Trainer Points: ${sum}",
              style: Theme.of(context).textTheme.headline1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () async {
                      if (count < 1) {
                        ShowCustomDialog(context, NoItemSelectedDialog());
                      } else {
                        int currentPoints =
                            await StoreUtils().getTrainerPoints();
                        if (currentPoints < sum) {
                          ShowCustomDialog(context, NotEnoughPointsDialog());
                        } else {
                          ShowCustomDialog(context, ConfirmPurchaseDialog());
                        }
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Buy",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Icon(
                            Icons.shopping_cart_checkout,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog NoItemSelectedDialog() {
    return AlertDialog(
      title: Text("No item selected"),
      content: Text("You didn't pick any number of ${widget.item.name}"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Accept"))
      ],
    );
  }

  AlertDialog NotEnoughPointsDialog() {
    return AlertDialog(
      title: Text("No can't buy these items"),
      content: Text("You don't have enough points to make the purchase"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("Accept"))
      ],
    );
  }

  AlertDialog ConfirmPurchaseDialog() {
    return AlertDialog(
      title: Text("Confirm your purchase"),
      content: Text(
          "Are you sure you want to buy $count ${widget.item.name} for ${sum} trainer points?"),
      actions: [
        TextButton(
            onPressed: () async {
              await StoreUtils().buyItem(widget.item, count);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("No"))
      ],
    );
  }
}
