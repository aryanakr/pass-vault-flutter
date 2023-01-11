import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/cupertino.dart';
import 'package:flutter_spinbox/material.dart';

class AdaptiveSpinBox extends StatelessWidget {

  final InputDecoration? decoration;
  final double value;
  final double min;
  final double max;
  final Function(double)? onChanged;

  const AdaptiveSpinBox({
    this.decoration,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoSpinBox(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        )
        : SpinBox(
          decoration: decoration,
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        );
  }
}