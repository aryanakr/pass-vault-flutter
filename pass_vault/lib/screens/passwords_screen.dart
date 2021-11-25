import 'package:flutter/material.dart';
import 'package:pass_vault/models/password_entry.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/screens/entry_detail_screen.dart';
import 'package:pass_vault/widgets/list_entry_password.dart';
import 'package:provider/provider.dart';
import 'package:pass_vault/screens/create_password_entry_screen.dart';

class PasswordsScreen extends StatelessWidget {
  const PasswordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false).authKey;
    return Scaffold(
      appBar: AppBar(
        title: Text('PassVault'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreatePasswordEntryScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(CreatePasswordEntryScreen.routeName);
        },
      ),
      body: FutureBuilder(
        future: Provider.of<PasswordEntries>(context, listen: false)
            .fetchAndSetEntries(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<PasswordEntries>(
                    child: Center(
                      child: Text('Got no passwords yet, add some!'),
                    ),
                    builder: (ctx, passwords, ch) => passwords.items.isEmpty
                        ? ch!
                        : ListView.builder(
                            itemCount: passwords.items.length,
                            itemBuilder: (ctx, i) => ListTile(
                              title: Text(passwords.items[i].title),
                              subtitle: passwords.items[i].website != null
                                  ? Text(passwords.items[i].website!)
                                  : passwords.items[i].email != null ? Text(passwords.items[i].email!) : null,
                              trailing: ListEntryPasswordWidget(passwords.items[i].retrieveActualPassword, auth!),
                              onTap: () {
                                Navigator.of(context).pushNamed(EntryDetailScreen.routeName, arguments: passwords.items[i].id);
                              },
                            ),
                          ),
                  ),
      ),
    );
  }
}
