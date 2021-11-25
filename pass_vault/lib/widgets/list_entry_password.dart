import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:string_encryption/string_encryption.dart';

class ListEntryPasswordWidget extends StatefulWidget {
  final String password;

  ListEntryPasswordWidget(this.password);

  @override
  _ListEntryPasswordWidgetState createState() =>
      _ListEntryPasswordWidgetState();
}

class _ListEntryPasswordWidgetState extends State<ListEntryPasswordWidget> {
  bool _passwordVisible = false;

  void _switchVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<String> retrieveActualPassword() async {
    final authKey = Provider.of<Auth>(context, listen: false).authKey!.trim();
    final cryptor = StringEncryption();

    final fakePassword = await cryptor.decrypt(widget.password, authKey);

    final storage = FlutterSecureStorage();
    String? actualPasswordEnc = await storage.read(key: fakePassword!);

    if (actualPasswordEnc == null) {
      return '';
    }

    final actualPassword = await cryptor.decrypt(actualPasswordEnc, authKey);
    return actualPassword!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_passwordVisible
          ? IconButton(
              icon: Icon(Icons.visibility_rounded),
              onPressed: _switchVisibility,
            )
          : FutureBuilder(
              future: retrieveActualPassword(),
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? CircularProgressIndicator()
                      : TextButton(
                          child: Text(snapshot.data.toString()),
                          onPressed: _switchVisibility,
                        ),
            ),
    );
  }
}
