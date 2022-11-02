import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/controllers/boxes.dart';
import 'package:pokimon/models/themes/theme.dart';
import 'package:pokimon/themes/app_themes.dart';
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

  var currentIndex = 1;

  @override
  Widget build(BuildContext context) {
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
          settingNavigatorTab(context, "Change password"),
          settingNavigatorTab(context, "Edit Profile Info"),
          settingNavigatorTab(context, "Privacy"),
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
              Theme.of(context).backgroundColor)
        ],
      ),
    );
  }

  Container settingNavigatorTab(BuildContext context, String title) {
    return widgetUnderlined(
        ListTile(
          onTap: () {
            print("Navigate to $title");
          },
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
}
