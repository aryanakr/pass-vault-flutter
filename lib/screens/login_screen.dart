import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/widgets/adaptive/adaptive_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passwordController = TextEditingController();

  bool isTextFieldObscured = true;

  Future<void> _loginWithPassword(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByPassword(_passwordController.text);
  }

  Future<void> _loginWithBiometrics(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchAndSetTokensByBio();
  }

  @override
  Widget build(BuildContext context) {

    final Widget body = SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(children: [
              // TODO: Add image of app icon
              const SizedBox(height: 8.0,),
              AdaptiveTextField(
                    label: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    obscureText: isTextFieldObscured,
                    enableSuggestions: false,
                    suffix: CupertinoButton(
                      child: Icon(isTextFieldObscured ? CupertinoIcons.eye : CupertinoIcons.eye_slash),
                      onPressed: () => setState(() => isTextFieldObscured = !isTextFieldObscured),
                    ),
                  ),
              const SizedBox(height: 16.0,),
              ElevatedButton(onPressed: () =>_loginWithPassword(context), child: const Text('Login'),),
              TextButton(onPressed: () => _loginWithBiometrics(context), child: const Text('Login with biometric authentication', style: TextStyle(fontSize: 16),))
            ],),
      ),
    );
    
    return Platform.isIOS ? 
      CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('PassVault'),
        ),
        child: body
      )
    : Scaffold(
      appBar: AppBar(title: const Text('PassVault'),),
      body: body,
    );
  }
}