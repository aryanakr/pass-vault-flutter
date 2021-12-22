import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();

  Future<void> _loginWithPassword(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByPassword(_passwordController.text);
  }

  Future<void> _loginWithBiometrics(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByBio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PassVault'),),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
          // TODO: Add image of app icon
          const SizedBox(height: 8.0,),
          TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                controller: _passwordController,
              ),
          const SizedBox(height: 16.0,),
          ElevatedButton(onPressed: () =>_loginWithPassword(context), child: const Text('Login'),),
          TextButton(onPressed: () => _loginWithBiometrics(context), child: const Text('Login with biometric authentication', style: TextStyle(fontSize: 16),))
        ],),
      ),
    );
  }
}