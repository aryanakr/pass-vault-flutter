import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextFormField extends StatelessWidget {

  final String? initialValue;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Function(String?) onSaved;
  final int? maxLines;
  final int? minLines;

  const AdaptiveTextFormField({
    this.initialValue,
    this.decoration,
    this.keyboardType,
    this.validator,
    this.maxLines,
    this.minLines,
    required this.onSaved,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoTextFormFieldRow(
          initialValue: initialValue,
          placeholder: decoration?.labelText,
          prefix: decoration?.suffixIcon,
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          minLines: minLines,
          maxLines: maxLines,
        )
        : TextFormField(
          initialValue: initialValue,
          decoration: decoration,
          keyboardType: keyboardType,
          validator: validator,
          onSaved: onSaved,
          minLines: minLines,
          maxLines: maxLines,
        );
  }
}