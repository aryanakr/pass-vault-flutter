import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/screens/entry_detail_screen.dart';
import 'package:pass_vault/widgets/list_entry_password.dart';
import 'package:provider/provider.dart';
import 'package:pass_vault/screens/create_entry_screen.dart';

class PasswordsScreen extends StatelessWidget {
  static const routeName = '/passwords-list';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false).authKey;

    final Widget body = SafeArea(
      child: FutureBuilder(
        future: Provider.of<PasswordEntries>(context, listen: false)
            .fetchAndSetEntries(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<PasswordEntries>(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                            'You don\'t have any password stored here yet!',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Text('Tap the + button to add new password entry.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Platform.isIOS
                                    ? CupertinoTheme.of(context).primaryColor
                                    : Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                ),
                builder: (ctx, passwords, ch) => passwords.items.isEmpty
                    ? ch!
                    : ListView.builder(
                        itemCount: passwords.items.length,
                        itemBuilder: (ctx, i) => Material(
                          child: ListTile(
                            title: Text(passwords.items[i].title),
                            subtitle: passwords.items[i].website != null
                                ? Text(passwords.items[i].website!)
                                : passwords.items[i].email != null
                                    ? Text(passwords.items[i].email!)
                                    : null,
                            trailing: ListEntryPasswordWidget(
                                passwords.items[i].retrieveActualPassword, auth!),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  EntryDetailScreen.routeName,
                                  arguments: passwords.items[i].id);
                            },
                          ),
                        ),
                      ),
              ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('PassVault'),
              trailing: CupertinoButton(
                child: Icon(CupertinoIcons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(CreateEntryScreen.routeName);
                },
              ),
            ),
            child: body,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('PassVault'),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(CreateEntryScreen.routeName);
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(CreateEntryScreen.routeName);
              },
            ),
            body: body);
  }
}
