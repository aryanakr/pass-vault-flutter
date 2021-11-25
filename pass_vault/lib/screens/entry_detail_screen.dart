import 'package:flutter/material.dart';
import 'package:pass_vault/models/password_entry.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/screens/edit_entry_screen.dart';
import 'package:pass_vault/screens/passwords_screen.dart';
import 'package:pass_vault/widgets/entry_detail_component.dart';
import 'package:pass_vault/widgets/list_entry_password.dart';
import 'package:provider/provider.dart';

class EntryDetailScreen extends StatelessWidget {
  static const routeName = '/detail-screen';

  void deleteEntryDialog(PasswordEntry entry, BuildContext context) {
    showDialog(context: context, builder: (BuildContext bctx) => AlertDialog(
      title: Text('Delete Entry'),
      content: Text('Are you sure you want to permanantly remove this password entry?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        TextButton(onPressed: () async {
          await Provider.of<PasswordEntries>(context, listen: false).deletePasswordEntry(entry);
          Navigator.of(context).pushReplacementNamed(PasswordsScreen.routeName);
        }, child: Text('Confirm'))
      ],
    ));
  }

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
          IconButton(onPressed: () => Navigator.of(context).pushReplacementNamed(EditEntryScreen.routeName,arguments: id), icon: Icon(Icons.edit)),
          IconButton(onPressed: () => deleteEntryDialog(passwordEntry, context), icon: Icon(Icons.delete))
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
