import 'package:flutter/material.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/widgets/entry_form.dart';
import 'package:provider/provider.dart';

class CreateEntryScreen extends StatelessWidget {
  static const routeName = '/create-entry';

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
    Future<void> submit() async {
      await Provider.of<PasswordEntries>(context, listen: false)
          .addPasswordEntry(
        title: formData['title']!,
        actualPassword: formData['password']!,
        website: formData['website']!,
        username: formData['username']!,
        email:  formData['email']!,
        description: formData['description']!,
      );
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: EntryFormWidget(
          formData: formData,
          passwordController: passwordController,
          submit: submit,
        ),
      ),
    );
  }
}
