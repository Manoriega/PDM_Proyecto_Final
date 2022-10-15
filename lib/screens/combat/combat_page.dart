import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CombatPage extends StatefulWidget {
  const CombatPage({super.key});

  @override
  State<CombatPage> createState() => _CombatPageState();
}

class _CombatPageState extends State<CombatPage> {
  @override
  Widget build(BuildContext context) {
    var statusBar = MediaQuery.of(context).viewPadding.top;
    var screenHeight = MediaQuery.of(context).size.height - statusBar;
    var screenWidth = MediaQuery.of(context).size.width - statusBar;
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
              SnackBar(content: Text("No puedes huir de un combate")));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: SizedBox(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.network(
                  "https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/134205305/original/e88fbf766161b5d8143af92cc0e4a5700907787e/draw-pixel-art-sprites-and-backgrounds.png",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: screenHeight * .13,
                        width: screenWidth * .8,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).disabledColor,
                                width: 4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Charmander"),
                                Text("Lv5"),
                              ],
                            ),
                            LinearPercentIndicator(
                              lineHeight: 8.0,
                              percent: 0.9,
                              progressColor: Colors.green,
                              backgroundColor: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * .2,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        "assets/images/spr_frlg_004.png",
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: screenHeight * .13,
                        width: screenWidth * .8,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Theme.of(context).disabledColor,
                                width: 4),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Bulbasaur"),
                                Text("Lv5"),
                              ],
                            ),
                            LinearPercentIndicator(
                              lineHeight: 8.0,
                              percent: 0.45,
                              progressColor: Colors.orange,
                              backgroundColor: Colors.grey,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "8/20",
                                  textAlign: TextAlign.end,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight * .2,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.bottomLeft,
                      child: Image.asset(
                        "assets/images/b_frlg_001.png",
                        width: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      height: screenHeight * .32,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xFFC7C7C7),
                          border: Border.all(
                              color: Theme.of(context).disabledColor, width: 2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          )),
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          actionButton("Pelear", Colors.red[300], () {
                            print("Pelear");
                          }),
                          actionButton("Mochila", Colors.green[300], () {
                            print("Mochila");
                          }),
                          actionButton("Equipo", Colors.brown[300], () {
                            print("Equipo");
                          }),
                          actionButton("Huir", Colors.deepOrange[300], () {
                            Navigator.of(context).pop();
                          }),
                        ],
                        childAspectRatio: (2),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container actionButton(String label, Color? color, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.all(5.0),
      child: MaterialButton(
        color: color,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
