import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();

  Future<void> _loginWithPassword(BuildContext context) async {
    final authRes = await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByPassword(_passwordController.text);
  }

  Future<void> _loginWithBiometrics(BuildContext context) async {
    final authRes = await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PassVault'),),
      body: Column(children: [
        TextField(
              decoration: InputDecoration(labelText: 'Password'),
              controller: _passwordController,
            ),
        ElevatedButton(onPressed: () =>_loginWithPassword(context), child: Text('Login')),
        TextButton(onPressed: () => _loginWithBiometrics(context), child: Text('Login with biometric authentication'))
      ],),
    );
  }
}