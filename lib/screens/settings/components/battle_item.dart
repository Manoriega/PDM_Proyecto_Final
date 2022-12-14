import 'package:flutter/material.dart';

class BattleItem extends StatelessWidget {
  final bool winner;
  final String winnerName;
  final DateTime date;
  const BattleItem(
      {super.key,
      required this.winner,
      required this.winnerName,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: winner ? Colors.green : Colors.red[400],
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Winner: ${winnerName}",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            toDate(date),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  toDate(DateTime dt) {
    return "${dt.day}-${dt.month}-${dt.year} at ${dt.hour}:${dt.minute}";
  }
}
