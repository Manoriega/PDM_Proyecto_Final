import 'package:flutter/material.dart';

class BattleItem extends StatelessWidget {
  const BattleItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "2022-10-31",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            "Ganador: TrainerMaster8x51",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
