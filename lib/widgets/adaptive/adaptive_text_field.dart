import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextField extends StatelessWidget {

  final String label;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final Widget? suffix;
  final bool obscureText;
  final bool enableSuggestions;

  const AdaptiveTextField({required this.label, this.keyboardType, this.suffix, this.enableSuggestions = false, this.obscureText = false, required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ?
     CupertinoTextField(
        placeholder: label,
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: enableSuggestions,
        suffix: suffix
     ) 
     : TextField(
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: enableSuggestions,
        
     );
  }
}