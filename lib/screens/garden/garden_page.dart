import 'package:flutter/material.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garden"),
      ),
      body: Center(
        child: Text("Garden"),
      ),
    );
  }
}
