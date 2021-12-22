import 'package:flutter/material.dart';

class EntryDetailComponent extends StatelessWidget {
  final String header;
  final Icon icon;
  final Widget value;

  EntryDetailComponent(this.header, this.icon ,this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(children: [
        Row(children: [
          icon,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(header, style: Theme.of(context).textTheme.headline5!.copyWith(color: Theme.of(context).primaryColorDark),),
          ),
        ]),
        value,
      ],),
    );
  }
}