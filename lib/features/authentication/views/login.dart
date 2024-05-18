import 'package:flutter/material.dart';
import 'package:holink/features/authentication/views/loginWidget/login.form.dart';

import 'package:holink/features/authentication/views/loginWidget/login.welcome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                LoginWelcome(),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
