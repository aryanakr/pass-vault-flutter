import 'package:flutter/material.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:pass_vault/widgets/entry_form.dart';
import 'package:provider/provider.dart';


class CreatePasswordEntryScreen extends StatelessWidget {
  static const routeName = '/create-password-entry';

  final Map<String, String> formData = {
    'title': '',
    'website': '',
    'username': '',
    'email': '',
    'password': '',
    'description': '',
  };

  final passwordController = TextEditingController();

  Future<void> submit(Map<String, String> data) async {
    print(formData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entry'),
      ),
      body: EntryFormWidget(formData: formData, passwordController: passwordController, submit: submit,),
    );
  }
}
