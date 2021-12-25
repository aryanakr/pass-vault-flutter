import 'package:flutter/material.dart';
import 'package:pass_vault/screens/auth_init_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome to PassVault", style: Theme.of(context).primaryTextTheme.headline4,),
            Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  "Start storing your day-to-day passwords in this application (very) securely!",
                  softWrap: true,
                  textAlign: TextAlign.center, 
                  style: Theme.of(context).primaryTextTheme.headline6,
                )),
            ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(AuthInitScreen.routeName),
                child: Text("Get Started"))
          ],
        ),
      ),
    );
  }
}
