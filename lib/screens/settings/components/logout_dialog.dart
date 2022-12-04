import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/screens/login/bloc/auth_bloc.dart';
import 'package:pokimon/screens/login/login_page.dart';

class LogOutDialog extends StatelessWidget {
  const LogOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
            onPressed: () async {
              //await _signOut();
              BlocProvider.of<AuthBloc>(context).add(SignOutEvent());
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => route is LoginPage);
            },
            child: Text("Yes")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Text("No"))
      ],
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

/* await _signOut();
                    Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const LoginPage(),
                        )); 
                        
                        */