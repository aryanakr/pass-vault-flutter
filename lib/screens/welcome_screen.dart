import 'package:flutter/material.dart';
import 'package:pass_vault/screens/auth_init_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Text("Welcome to PassVault"),
        Text("This App lets you store your day-to-day password securely"),
        ElevatedButton(onPressed: () => Navigator.of(context).pushReplacementNamed(AuthInitScreen.routeName), child: Text("Get Started"))
      ],),
    );
  }
}