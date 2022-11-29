import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/components/error_text.dart';
import 'package:pokimon/components/input.dart';
import 'package:pokimon/screens/settings/bloc/user_bloc.dart';
import 'package:pokimon/screens/settings/components/profile_screen.dart';

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
              updateUser(newUsernameController.text);
              BlocProvider.of<UserBloc>(context).add(ResetProfileEvent());
              BlocProvider.of<UserBloc>(context).add(GetMyProfileEvent());
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
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

  CollectionReference users =
      FirebaseFirestore.instance.collection('pocket_users');

  Future<void> updateUser(String newUSERString) {
    return users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'username': newUSERString})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
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
