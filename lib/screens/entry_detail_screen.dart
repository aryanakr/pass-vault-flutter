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
                'Title', Icon(Icons.title), Text(passwordEntry.title, style: Theme.of(context).textTheme.headline6!,)),

            if (passwordEntry.website != null &&
                !passwordEntry.website!.isEmpty)
              EntryDetailComponent(
                  'Website', Icon(Icons.link), Text(passwordEntry.website!, style: Theme.of(context).textTheme.headline6!,)),

            if (passwordEntry.email != null && passwordEntry.email!.isNotEmpty)
              EntryDetailComponent(
                  'Email', Icon(Icons.email), Text(passwordEntry.email!, style: Theme.of(context).textTheme.headline6!,)),

            if (passwordEntry.username != null &&
                passwordEntry.username!.isNotEmpty)
              EntryDetailComponent(
                  'Username', const Icon(Icons.face), Text(passwordEntry.username!, style: Theme.of(context).textTheme.headline6!,)),


            EntryDetailComponent(
                  'Password', Icon(Icons.password), ListEntryPasswordWidget(
                passwordEntry.retrieveActualPassword, auth!),),

            if (passwordEntry.description != null &&
                passwordEntry.description!.isNotEmpty)
              EntryDetailComponent('Description', const Icon(Icons.description),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.75,child: Text(passwordEntry.description!, style: Theme.of(context).textTheme.headline6!,))),
          ],
        ),
      ),
    );
  }
}
