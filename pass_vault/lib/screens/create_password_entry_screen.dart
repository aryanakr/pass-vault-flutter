import 'package:flutter/material.dart';
import 'package:pass_vault/providers/password_entries.dart';
import 'package:provider/provider.dart';

import 'package:random_password_generator/random_password_generator.dart';

class CreatePasswordEntryScreen extends StatelessWidget {
  static const routeName = '/create-password-entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entry'),
      ),
      body: CreateEntryForm(),
    );
  }
}

class CreateEntryForm extends StatefulWidget {
  @override
  State<CreateEntryForm> createState() => _CreateEntryFormState();
}

class _CreateEntryFormState extends State<CreateEntryForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _formData = {
    'title': '',
    'website': '',
    'username': '',
    'email': '',
    'password': '',
    'description': '',
  };

  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    _formData['password'] = _passwordController.text;
    await Provider.of<PasswordEntries>(context, listen: false).addPasswordEntry(
      _formData['title']!,
      _formData['password']!,
      _formData['website']!,
      _formData['username']!,
      _formData['email']!,
      _formData['description']!,
    );
    Navigator.of(context).pop();
  }

  Future<void> _generatePassword() async {
    final password = RandomPasswordGenerator();

    String newPassword = password.randomPassword(
        letters: true,
        numbers: true,
        uppercase: true,
        specialChar: false,
        passwordLength: 8);

    setState(() {
      _passwordController.text = newPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Title', suffixIcon: Icon(Icons.title)),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title can not be empty!';
                }
                return null;
              },
              onSaved: (value) {
                _formData['title'] = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Website', suffixIcon: Icon(Icons.link)),
              keyboardType: TextInputType.url,
              onSaved: (value) {
                _formData['website'] = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'E-Mail', suffixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                _formData['email'] = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Username', suffixIcon: Icon(Icons.face)),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                _formData['username'] = value!;
              },
            ),
            // TODO: Replace with a widget
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: 'Password', suffixIcon: Icon(Icons.password)),
              keyboardType: TextInputType.visiblePassword,
            ),
            ElevatedButton(
                onPressed: _generatePassword, child: Text('Generate')),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'description',
                  suffixIcon: Icon(Icons.description)),
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                _formData['description'] = value!;
              },
            ),
            ElevatedButton(onPressed: _submit, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
}
