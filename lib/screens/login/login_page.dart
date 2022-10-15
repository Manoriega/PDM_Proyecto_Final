import 'package:flutter/material.dart';
import 'package:pokimon/screens/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var usernameController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline2,
            ),
            Text("Please sign in to continue"),
            iconInput(context, Icons.account_box_rounded, "Username",
                usernameController),
            iconInput(context, Icons.lock, "Password", passwordController),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomePage()));
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
            )
          ],
        ),
      ),
    );
  }

  Container iconInput(BuildContext context, IconData icon, String placeholder,
      TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(
        leading: Icon(
          icon,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
              enabledBorder: Theme.of(context).inputDecorationTheme.border,
              labelText: placeholder),
        ),
      ),
    );
  }
}
