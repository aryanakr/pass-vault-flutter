import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:string_encryption/string_encryption.dart';

class ListEntryPasswordWidget extends StatefulWidget {
  final Future<String> Function(String authKey) getPassword;
  final String authKey;

  ListEntryPasswordWidget(this.getPassword, this.authKey);

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
  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_passwordVisible
          ? IconButton(
              icon: Icon(Icons.visibility_rounded),
              onPressed: _switchVisibility,
            )
          : FutureBuilder(
              future: widget.getPassword(widget.authKey),
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
