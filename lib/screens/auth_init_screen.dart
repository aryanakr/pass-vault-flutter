import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';

import 'package:provider/provider.dart';

import 'package:flutter_locker/flutter_locker.dart';
import 'package:pass_vault/screens/login_screen.dart';
import 'package:string_encryption/string_encryption.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInitScreen extends StatefulWidget {
  static const routeName = '/auth-init-screen';

  @override
  _AuthInitScreenState createState() => _AuthInitScreenState();
}

class _AuthInitScreenState extends State<AuthInitScreen> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  var _bioAuthCheckedValue = false;

  void _checkBioAuthAvailable(BuildContext ctx) {
    FlutterLocker.canAuthenticate().then((value) {
      if (!value!) {
        ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Biometric authenticate unavailable')));
      } else {
        setState(() {
          _bioAuthCheckedValue = true;
        });
      }
    }).catchError((err) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content:
              Text('Error with biometric authentication: ' + err.toString())));
    });
  }

  Future<void> _submitInitialisation(BuildContext context) async {
    // validation
    if (_passwordController.text.length < 8) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Password is too short!')));
      return;
    }
    if (_passwordConfirmController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password and confirmation fields do not match!')));
      return;
    }

    await Provider.of<Auth>(context, listen: false)
        .initialiseAuth(_passwordController.text, _bioAuthCheckedValue);

    // navigate to login page
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Started'),
      ),
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: _passwordController,
              ),
              SizedBox(height: 8.0,),
              TextField(
                decoration: InputDecoration(labelText: 'Password Confirmation'),
                controller: _passwordConfirmController,
              ),
              SizedBox(height: 32.0,),
              CheckboxListTile(
                title: Text("Enable Biometric Authentication"),
                value: _bioAuthCheckedValue,
                onChanged: (newValue) {
                  if (newValue!) {
                    _checkBioAuthAvailable(context);
                  } else {
                    setState(() {
                      _bioAuthCheckedValue = false;
                    });
                  }
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              ElevatedButton(
                onPressed: () => _submitInitialisation(context),
                child: Text('Submit'),
              )
            ],
          ),
        );
      }),
    );
  }
}
