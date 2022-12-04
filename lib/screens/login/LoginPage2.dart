import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokimon/components/loading_screen.dart';
import 'package:pokimon/screens/begginer/beginner_page.dart';
import 'package:pokimon/screens/home/home_page.dart';
import 'package:pokimon/screens/login/bloc/auth_bloc.dart';
import 'package:pokimon/themes/provider/themes_provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../../utils/secrets.dart' as Secrets;
import '../signin/signin_page.dart';

class LoginPage2 extends StatefulWidget {
  const LoginPage2({super.key});

  @override
  State<LoginPage2> createState() => _LoginPage2State();
}

class _LoginPage2State extends State<LoginPage2> {
  var emailController = TextEditingController(),
      passwordController = TextEditingController(),
      emailErrors = "",
      passwordErrors = "",
      isLoading = false;
  final random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Favor de autenticarse"),
              ),
            );
          }
          if (state is AuthUserHasEnteredForTheFirstTime) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => BegginnerPage(),
              ),
            );
          }

          if (state is AuthSuccessState) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => HomePage(),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthAwaitingState) {
            return LoadingScreen();
          }

          return Padding(
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
                        style: TextStyle(
                            color: Theme.of(context).errorColor,
                            fontSize: 0.01),
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
                          if (validateCredentials(emailController.text,
                                  passwordController.text) ==
                              true) {
                            BlocProvider.of<AuthBloc>(context).add(
                                EmailAuthEvent(passwordController.text,
                                    emailController.text));
                          }
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
                          : Buttons.google, onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(GoogleAuthEvent());
                  }),
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
          );
        },
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
      emailErrors += "Email not valid";
      flag = flag && false;
    }
    if (password.length < 8 && password.isNotEmpty) {
      passwordErrors += "Password must have 8 characters or more";
      flag = flag && false;
    }
    setState(() {});
    return flag;
  }
}
