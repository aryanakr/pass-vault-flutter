import 'package:flutter/material.dart';

import 'package:random_password_generator/random_password_generator.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

class PasswordGeneratorWidget extends StatefulWidget {
  final TextEditingController textFieldController;

  PasswordGeneratorWidget(this.textFieldController);

  @override
  _PasswordGeneratorWidgetState createState() =>
      _PasswordGeneratorWidgetState();
}

class _PasswordGeneratorWidgetState extends State<PasswordGeneratorWidget> {
  bool _isWithLetters = true;
  bool _isWithUppercase = false;
  bool _isWithNumbers = false;
  bool _isWithSpecial = false;
  double _numberCharPassword = 8;

  Future<void> _generatePassword() async {
    final password = RandomPasswordGenerator();
    String newPassword = password.randomPassword(
        letters: _isWithLetters,
        numbers: _isWithNumbers,
        uppercase: _isWithUppercase,
        specialChar: _isWithSpecial,
        passwordLength: _numberCharPassword);

    setState(() {
      widget.textFieldController.text = newPassword;
    });
  }

  labeledSwitch(String label, bool val, Function(bool) update) {
    return Row(
      children: [
        Text(label),
        Switch(value: val, onChanged: update),
      ],
    );
  }

  // TODO: Create Strength inidicator widget
  // strengthDisplay(){
  //   final password = RandomPasswordGenerator();
  //   double passwordstrength = password.checkPassword(password: widget.textFieldController.text);

  //   if (passwordstrength < 0.3)
  //       print('This password is weak!');
  //   else if (passwordstrength < 0.7)
  //       print('This password is Good');
  //   else
  //       print('This passsword is Strong');
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.textFieldController,
          decoration: const InputDecoration(
            labelText: 'Password',
            suffixIcon: Icon(Icons.password),
          ),
          keyboardType: TextInputType.visiblePassword,
        ),
        Card(
            child: Padding(
          padding: EdgeInsets.all(0.0),
          child: ExpansionTile(
            title: const Text('Password Generator'),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  labeledSwitch(
                      'Letters',
                      _isWithLetters,
                      (value) => setState(() {
                            _isWithLetters = value;
                          })),
                  labeledSwitch(
                      'Numbers',
                      _isWithNumbers,
                      (value) => setState(() {
                            _isWithNumbers = value;
                          })),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  labeledSwitch(
                      'Upper Case',
                      _isWithUppercase,
                      (value) => setState(() {
                            _isWithUppercase = value;
                          })),
                  labeledSwitch(
                    'Symbols',
                    _isWithSpecial,
                    (value) => setState(() {
                      _isWithSpecial = value;
                    }),
                  ),
                ],
              ),
              SizedBox(
                width: 250.0,
                child: SpinBox(
                  decoration: const InputDecoration(labelText: 'Length',),
                  min: 1,
                  max: 30,
                  value: 8,
                  onChanged: (value) => setState(() {
                    _numberCharPassword = value;
                  }),
                ),
              ),
              const SizedBox(height: 8.0,),
              ElevatedButton(
                  onPressed: _generatePassword, child: Text('Generate')),
            ],
          ),
        ))
      ],
    );
  }
}
