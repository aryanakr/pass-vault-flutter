import 'package:flutter/material.dart';

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
        Scaffold.of(ctx).showSnackBar(
            SnackBar(content: Text('Biometric authenticate unavailable')));
      } else {
        setState(() {
          _bioAuthCheckedValue = true;
        });
      }
    }).catchError((err) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content:
              Text('Error with biometric authentication: ' + err.toString())));
    });
  }

  Future<void> _submitInitialisation(BuildContext context) async {
    // validation
    if (_passwordController.text.length < 8) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Password is too short!')));
      return;
    }
    if (_passwordConfirmController.text != _passwordConfirmController.text) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Password and confirmation fields do not match!')));
      return;
    }

    // Locker <- bioauth : password
    if (_bioAuthCheckedValue) {
      FlutterLocker.save(SaveSecretRequest('bioauth', _passwordController.text,
              AndroidPrompt('Authenticate', 'Cancel')))
          .then((value) {})
          .catchError((err) {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error happened (try disabling biometric authentication): ' +
                    err.toString())));
        return;
      });
    }

    final cryptor = StringEncryption();
    
    // generate entry salt
    final entrySalt = await cryptor.generateSalt();

    // entryTokenKey =  encrypt entry salt with password
    final entryTokenKey = await cryptor.generateKeyFromPassword(
        _passwordController.text, entrySalt!);

    // shared pref <- passvaultinit : entrySalt
    final storage = FlutterSecureStorage();

    await storage.write(key: "passvaultinit", value: entrySalt);

    // generate sql password
    final sqlKey = await cryptor.generateRandomKey();

    // Encrypted shared pref <- entryTokenKey : sql password
    

    await storage.write(key: entryTokenKey!, value: sqlKey);

    // navigate to login page
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Started'),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Password'),
              controller: _passwordController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Password Confirmation'),
              controller: _passwordConfirmController,
            ),
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
                child: Text('Submit'))
          ],
        );
      }),
    );
  }
}
