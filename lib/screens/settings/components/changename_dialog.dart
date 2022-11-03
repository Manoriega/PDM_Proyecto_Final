import 'package:flutter/material.dart';
import 'package:pokimon/components/error_text.dart';
import 'package:pokimon/components/input.dart';

class ChangeNameDialog extends StatefulWidget {
  const ChangeNameDialog({super.key});

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  var newUsernameController = TextEditingController(),
      userNameErrors = "",
      acceptErrors = "",
      acceptChange = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Nombre de usuario"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Input(context, false, false, false, newUsernameController,
              "Nuevo nombre de usuario", userNameErrors),
          ListTile(
            title: Text("Aceptas cambiar tu usuario?"),
            leading: Checkbox(
                value: acceptChange,
                onChanged: (value) => setState(() {
                      acceptChange = value!;
                    })),
          ),
          ErrorText(acceptErrors, context)
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              validateUserName(newUsernameController.text, acceptChange);
            },
            child: Text("Sí")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("No")),
      ],
    );
  }

  void validateUserName(String text, bool acceptChange) {
    acceptErrors = "";
    userNameErrors = "";
    if (!acceptChange) {
      acceptErrors += "Debes aceptar que cambiará tu usuario";
    }
    setState(() {});
  }
}
