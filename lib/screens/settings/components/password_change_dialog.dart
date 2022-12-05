import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokimon/classes/Pokemon.dart';
import 'package:pokimon/screens/combat/CombatMainPage.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/login_page.dart';

class PasswordChangedDialog extends StatelessWidget {
  const PasswordChangedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("You've changed your password."),
      content: Text("Your password has been changed successfully."),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text("Accept")),
      ],
    );
  }
}

/* await _signOut();
                    Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const LoginPage(),
                        )); 
                        
                        */