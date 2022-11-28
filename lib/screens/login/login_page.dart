import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/signin/signin_page.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../themes/provider/themes_provider.dart';
import '../../utils/secrets.dart' as Secrets;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController(),
      passwordController = TextEditingController(),
      emailErrors = "",
      passwordErrors = "",
      isLoading = false;
  final random = Random();

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('pocket_users');
    if (isLoading == true) {
      return LoadingScreen();
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/LOGIN THING.png",
              color: Theme.of(context).primaryColor,
            ),
            Text("Please log in to continue"),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_box_rounded,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          enabledBorder:
                              Theme.of(context).inputDecorationTheme.border,
                          labelText: "Email"),
                    ),
                  ),
                  Text(
                    emailErrors,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.lock,
                      size: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: TextField(
                      obscureText: true,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: passwordController,
                      decoration: InputDecoration(
                          enabledBorder:
                              Theme.of(context).inputDecorationTheme.border,
                          labelText: "Password"),
                    ),
                  ),
                  Text(
                    passwordErrors,
                    style: TextStyle(color: Theme.of(context).errorColor),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      logInWithMail(
                          emailController.text, passwordController.text, users);
                    },
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "LOGIN",
                            style: TextStyle(fontSize: 30),
                          ),
                          Icon(
                            Icons.login,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignInButton(
                  (context.read<ColorSchemeProvider>().isDark == true)
                      ? Buttons.googleDark
                      : Buttons.google,
                  onPressed: () {}),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignInPage(),
                    ),
                  );
                },
                child: Text("No tienes cuenta? Registrate aqui")),
          ],
        ),
      ),
    );
  }

  int next(int min, int max) => min + random.nextInt(max - min);

  bool validateCredentials(String email, String password) {
    var flag = true;
    emailErrors = "";
    passwordErrors = "";
    if (email == "") {
      emailErrors += "Email is required. ";
      flag = flag && false;
    }
    if (password == "") {
      passwordErrors += "Password is required. ";
      flag = flag && false;
    }
    if (email.isNotEmpty &&
        RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*")
                .hasMatch(email) ==
            false) {
      emailErrors += "Email doesn't have format (example@example.com). ";
      flag = flag && false;
    }
    if (password.length < 8 && password.isNotEmpty) {
      passwordErrors += "Password must have 8 characters or more. ";
      flag = flag && false;
    }
    setState(() {});
    return flag;
  }

  Future<void> logInWithMail(
      String email, String password, CollectionReference users) async {
    if (validateCredentials(email, password) == true) {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) => {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage(),
                  ),
                )
              })
          .catchError((e) => print(e));
    }
  }

  Future<void> createUser(CollectionReference users, String userId) async {
    users.doc(userId).set(
      {
        'username':
            "TrainerMaster${next(0, 1000000)}x${next(0, 1000000)}${next(0, 1000000)}",
        "createdAt": DateTime.now().millisecondsSinceEpoch,
        "trainerPoints": 0,
        "battles": []
      },
    );
  }
}
