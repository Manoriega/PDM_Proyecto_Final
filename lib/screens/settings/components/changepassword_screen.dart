import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/components/error_text.dart';
import 'package:pokimon/components/input.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/components/show_custom_dialog.dart';
import 'package:pokimon/screens/settings/components/password_change_dialog.dart';

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
      acceptChange = false,
      loading = false;
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Change password'),
          ),
          body: Center(child: (CircularProgressIndicator())));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Change password'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Change your password",
            style: Theme.of(context).textTheme.headline4,
          ),
          Input(context, true, false, false, lastPasswordController,
              "Last password", lastPasswordErrors),
          Input(context, true, false, false, newPasswordController,
              "New password", newPasswordErrors),
          Input(context, true, false, false, validatePasswordController,
              "Enter your password again", validatePasswordErrors),
          ListTile(
            title: Text("Are you sure you want to change your password?"),
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
                    onPressed: () async {
                      if (submitPassord(
                          lastPasswordController.text,
                          newPasswordController.text,
                          validatePasswordController.text,
                          acceptChange)) {
                        _changePassword(lastPasswordController.text,
                            newPasswordController.text);
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Change password",
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
    var valid = true;
    if (acceptChange == false) {
      checkErrors += "You must accept changing your password.";
      valid = false;
    }
    if (lastPassword == "") {
      lastPasswordErrors += "Password is required. ";
      valid = false;
    }
    if (newPassword.length < 8 && newPassword.isNotEmpty) {
      newPasswordErrors += "Password must have 8 characters or more. ";
      valid = false;
    }
    if (newPassword == "") {
      newPasswordErrors += "Password is required. ";
      valid = false;
    }
    if (validatePassword == "") {
      validatePasswordErrors += "Password is required. ";
      valid = false;
    }
    if (validatePassword != newPassword) {
      validatePasswordErrors += "Your new password doesn't match.";
      valid = false;
    }
    setState(() {});
    return valid;
  }

  void _changePassword(String currentPassword, String newPassword) async {
    setState(() {
      loading = true;
    });
    final user = await FirebaseAuth.instance.currentUser;
    final _email = user?.email;
    final cred = EmailAuthProvider.credential(
        email: _email.toString(), password: currentPassword);
    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        setState(() {
          loading = false;
        });
        ShowCustomDialog(context, PasswordChangedDialog());
      }).catchError((error) {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong. Please try again."),
          ),
        );
      });
    }).catchError((err) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Last password doesn't match with your current password."),
        ),
      );
    });
  }
}
