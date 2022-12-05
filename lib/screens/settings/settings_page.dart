import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/controllers/boxes.dart';
import 'package:pokimon/models/themes/theme.dart';
import 'package:pokimon/screens/login/login_page.dart';
import 'package:pokimon/screens/settings/bloc/user_bloc.dart';
import 'package:pokimon/screens/settings/components/battle_item.dart';
import 'package:pokimon/screens/settings/components/changepassword_screen.dart';
import 'package:pokimon/screens/settings/components/logout_dialog.dart';
import 'package:pokimon/screens/settings/components/profile_screen.dart';
import 'package:pokimon/themes/app_themes.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:provider/provider.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int? currentRadio = Boxes.getThemeBox().getAt(0)?.flexSchemeData;
  bool? isDark = Boxes.getThemeBox().getAt(0)?.isDark;

  var currentIndex = 1, loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Column(
        children: [
          subConfigDivider(context, Icons.account_circle, "Account"),
          settingNavigatorTab(context, "Change password", () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordScreen()));
          }),
          settingNavigatorTab(context, "Profile Info", () async {
            setState(() {
              loading = true;
            });
            BlocProvider.of<UserBloc>(context).add(ResetProfileEvent());
            BlocProvider.of<UserBloc>(context).add(GetMyProfileEvent());
            List<BattleItem> battles = await getUserBattles();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfileScreen(
                      battles: battles,
                    )));
            setState(() {
              loading = false;
            });
          }),
          subConfigDivider(context, Icons.more, "More"),
          widgetUnderlined(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: getRadioButtons(),
              ),
              Theme.of(context).backgroundColor),
          widgetUnderlined(
              ListTile(
                leading: Text("Dark Mode?",
                    style: Theme.of(context).textTheme.subtitle1),
                trailing: Switch(
                  value: isDark!,
                  onChanged: (value) {
                    context.read<ColorSchemeProvider>().switchMode(
                        value ? ThemeMode.dark : ThemeMode.light, true);
                    setState(() {
                      isDark = value;
                    });
                    ThemeHive().addTheme(currentRadio!, value);
                  },
                ),
              ),
              Theme.of(context).backgroundColor),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () async {
                    ShowCustomDialog(context, LogOutDialog());
                  },
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "LOGOUT",
                          style: TextStyle(fontSize: 30),
                        ),
                        Icon(
                          Icons.logout,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container settingNavigatorTab(
      BuildContext context, String title, VoidCallback function) {
    return widgetUnderlined(
        ListTile(
          onTap: function,
          leading: Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: Icon(
            Icons.arrow_forward,
            size: 35,
          ),
        ),
        Theme.of(context).backgroundColor);
  }

  Container widgetUnderlined(Widget child, Color background) {
    return Container(
      decoration: BoxDecoration(
        color: background,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).disabledColor),
        ),
      ),
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: child,
    );
  }

  Container subConfigDivider(
      BuildContext context, IconData icon, String title) {
    return widgetUnderlined(
        ListTile(
          iconColor: Theme.of(context).iconTheme.color,
          title: Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
          leading: Icon(
            icon,
            size: 50,
          ),
        ),
        Theme.of(context).dividerColor);
  }

  List<Widget> getRadioButtons() {
    List<Widget> list = [];
    for (var i = 0; i < appThemeData.length; i++) {
      var itemAppTheme = AppTheme.values[i],
          itemThemeData = appThemeData[itemAppTheme];
      list.add(
        Transform.scale(
          scale: 1.5,
          child: Radio(
            activeColor: isDark!
                ? itemThemeData?.dark.primary
                : itemThemeData?.light.primary,
            value: i,
            groupValue: currentRadio,
            onChanged: (int? value) {
              currentRadio = value;
              context
                  .read<ColorSchemeProvider>()
                  .changeCurrentTheme(itemThemeData!, true);
              ThemeHive().addTheme(itemAppTheme.index, isDark!);
            },
          ),
        ),
      );
    }
    return list;
  }

  getUserBattles() async {
    var queryUser = FirebaseFirestore.instance
            .collection("pocket_users")
            .doc(FirebaseAuth.instance.currentUser!.uid),
        docsRef = await queryUser.get(),
        listIds = docsRef.data()?["battles"];
    var queryBattles =
        await FirebaseFirestore.instance.collection("pocket_battles").get();

    var myBattles = queryBattles.docs
        .where((doc) => listIds.contains(doc.id))
        .map((doc) => doc.data().cast<String, dynamic>())
        .toList();
    List<BattleItem> battlesWidgets = [];
    var username = docsRef.data()?["username"];
    for (var i = 0; i < myBattles.length; i++) {
      var battleDoc = myBattles[i],
          isPlayerWinner =
              battleDoc["Winner"] == FirebaseAuth.instance.currentUser!.uid;
      var date = battleDoc["createdAt"].toDate();
      BattleItem battle = BattleItem(
          winner: isPlayerWinner,
          winnerName: isPlayerWinner ? username : battleDoc["Winner"],
          date: date);
      battlesWidgets.add(battle);
    }
    return battlesWidgets;
  }
}
