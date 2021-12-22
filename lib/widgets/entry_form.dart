import 'package:flutter/material.dart';
import 'package:pass_vault/widgets/password_generator.dart';

class EntryFormWidget extends StatefulWidget {
  final Map<String, String> formData;
  final TextEditingController passwordController;
  final Future<void> Function() submit;

  EntryFormWidget({
    required this.formData,
    required this.passwordController,
    required this.submit,
  });

  @override
  _EntryFormWidgetState createState() => _EntryFormWidgetState();
}

class _EntryFormWidgetState extends State<EntryFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _confirmSubmition() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.formData['password'] = widget.passwordController.text;

    widget.submit();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.formData['title'],
              decoration: const InputDecoration(
                  labelText: 'Title', suffixIcon: Icon(Icons.title)),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Title can not be empty!';
                }
                return null;
              },
              onSaved: (value) {
                widget.formData['title'] = value!;
              },
            ),
            TextFormField(
              initialValue: widget.formData['website'],
              decoration: const InputDecoration(
                  labelText: 'Website', suffixIcon: Icon(Icons.link)),
              keyboardType: TextInputType.url,
              onSaved: (value) {
                widget.formData['website'] = value!;
              },
            ),
            TextFormField(
              initialValue: widget.formData['email'],
              decoration: const InputDecoration(
                  labelText: 'E-Mail', suffixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                widget.formData['email'] = value!;
              },
            ),
            TextFormField(
              initialValue: widget.formData['username'],
              decoration: const InputDecoration(
                  labelText: 'Username', suffixIcon: Icon(Icons.face)),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                widget.formData['username'] = value!;
              },
            ),
            const SizedBox(height: 8.0,),
            PasswordGeneratorWidget(widget.passwordController),
            const SizedBox(height: 8.0,),
            TextFormField(
              initialValue: widget.formData['description'],
              minLines: 1,
              maxLines: 5,
              decoration: const InputDecoration(
                  labelText: 'description',
                  suffixIcon: Icon(Icons.description)),
              keyboardType: TextInputType.multiline,
              onSaved: (value) {
                widget.formData['description'] = value!;
              },
            ),
            const SizedBox(height: 8.0,),
            ElevatedButton(
                onPressed: _confirmSubmition, child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
