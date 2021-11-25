import 'package:flutter/material.dart';
import 'package:pass_vault/models/password_entry.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/widgets/entry_detail_component.dart';
import 'package:pass_vault/widgets/list_entry_password.dart';
import 'package:provider/provider.dart';

class EntryDetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final passwordEntry =
        Provider.of<PasswordEntries>(context, listen: false).findEntryById(id);
    final auth = Provider.of<Auth>(context, listen: false).authKey;

    return Scaffold(
      appBar: AppBar(
        title: Text(passwordEntry.title),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EntryDetailComponent(
                'Title', Icon(Icons.title), passwordEntry.title),

            if (passwordEntry.website != null &&
                !passwordEntry.website!.isEmpty)
              EntryDetailComponent(
                  'Website', Icon(Icons.link), passwordEntry.website!),

            if (passwordEntry.email != null && !passwordEntry.email!.isEmpty)
              EntryDetailComponent(
                  'Email', Icon(Icons.email), passwordEntry.email!),

            if (passwordEntry.username != null &&
                !passwordEntry.username!.isEmpty)
              EntryDetailComponent(
                  'Username', Icon(Icons.face), passwordEntry.username!),

            Row(children: [
              Icon(Icons.password),
              Text('Password'),
            ],),
            ListEntryPasswordWidget(
                passwordEntry.retrieveActualPassword, auth!),

            if (passwordEntry.description != null &&
                !passwordEntry.description!.isEmpty)
              EntryDetailComponent('Description', Icon(Icons.description),
                  passwordEntry.description!),
          ],
        ),
      ),
    );
  }
}