import 'package:flutter/material.dart';

class EntryDetailComponent extends StatelessWidget {
  final String header;
  final Icon icon;
  final String value;

  EntryDetailComponent(this.header, this.icon ,this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Row(children: [
          icon,
          Text(header),
        ]),
        Text(value),
      ],),
    );
  }
}