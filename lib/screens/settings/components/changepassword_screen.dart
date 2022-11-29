import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/components/error_text.dart';
import 'package:pokimon/components/input.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var lastPasswordController = TextEditingController(),
      newPasswordController = TextEditingController(),
      validatePasswordController = TextEditingController(),
      lastPasswordErrors = "",
      newPasswordErrors = "",
      validatePasswordErrors = "",
      checkErrors = "",
      formErrors = "",
      acceptChange = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Cambiar contraseña'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Cambia tu contraseña",
            style: Theme.of(context).textTheme.headline4,
          ),
          Input(context, true, false, false, lastPasswordController,
              "Antigua contraseña", lastPasswordErrors),
          Input(context, true, false, false, newPasswordController,
              "Nueva contraseña", newPasswordErrors),
          Input(context, true, false, false, validatePasswordController,
              "Ingresa de nuevo la contraseña", validatePasswordErrors),
          ListTile(
            title: Text("Aceptas cambiar tu contraseña?"),
            leading: Checkbox(
                value: acceptChange,
                onChanged: (value) => setState(() {
                      acceptChange = value!;
                    })),
          ),
          ErrorText(checkErrors, context),
          ErrorText(formErrors, context),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                    onPressed: () => submitPassord(
                        lastPasswordController.text,
                        newPasswordController.text,
                        validatePasswordController.text,
                        acceptChange),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cambiar Contraseña",
                        style: TextStyle(fontSize: 30),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  submitPassord(String lastPassword, String newPassword,
      String validatePassword, bool acceptChange) {
    checkErrors = "";
    lastPasswordErrors = "";
    newPasswordErrors = "";
    validatePasswordErrors = "";
    if (acceptChange == false) {
      checkErrors += "Debes aceptar para cambiar tu contraseña. ";
    }
    if (lastPassword == "") {
      lastPasswordErrors += "Password is required. ";
    }
    if (newPassword == "") {
      newPasswordErrors += "Password is required. ";
    }
    if (validatePassword == "") {
      validatePasswordErrors += "Password is required. ";
    }
    if (validatePassword != newPassword) {
      validatePasswordErrors += "No coincide tu nueva contraseña. ";
    }
    _changePassword(lastPassword, newPassword);
    setState(() {});
  }

  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final _email = user?.email;
    final cred = EmailAuthProvider.credential(
        email: _email.toString(), password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
        print("Les go");
      }).catchError((error) {
        print(error);
        //Error, show something
      });
    }).catchError((err) {});
  }
}
