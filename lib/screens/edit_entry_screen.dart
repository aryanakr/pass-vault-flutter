import 'package:flutter/material.dart';
import 'package:pass_vault/providers/auth.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/screens/entry_detail_screen.dart';
import 'package:pass_vault/widgets/entry_form.dart';
import 'package:provider/provider.dart';

class EditEntryScreen extends StatelessWidget {
  static const routeName = '/edit-entry';

  final Map<String, String> formData = {
    'title': '',
    'website': '',
    'username': '',
    'email': '',
    'password': '',
    'description': '',
  };

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final passwordEntry =
        Provider.of<PasswordEntries>(context, listen: false).findEntryById(id);

    Future<void> _updateInitialFormValues() async {
      final auth = Provider.of<Auth>(context, listen: false).authKey;
      formData['title'] = passwordEntry.title;
      formData['website'] = passwordEntry.website ?? '';
      formData['username'] = passwordEntry.username ?? '';
      formData['email'] = passwordEntry.email ?? '';
      formData['description'] = passwordEntry.description ?? '';
      formData['password'] = await passwordEntry.retrieveActualPassword(auth!);

      passwordController.text = formData['password']!;
    }

    Future<void> submit() async {
      await Provider.of<PasswordEntries>(context, listen: false)
          .updatePasswordEntry(
        id,
        formData['title']!,
        formData['password']!,
        formData['website']!,
        formData['username']!,
        formData['email']!,
        formData['description']!,
      );
      Navigator.of(context).pushReplacementNamed(EntryDetailScreen.routeName, arguments: id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
      ),
      body: FutureBuilder(
        future: _updateInitialFormValues(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : EntryFormWidget(
                    formData: formData,
                    passwordController: passwordController,
                    submit: submit,
                  ),
      ),
    );
  }
}
