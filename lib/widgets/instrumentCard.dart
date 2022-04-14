import 'package:admin/Resources/Color.dart';
import 'package:admin/dataClasses/Instruments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class instrumentcard extends StatelessWidget {
  Instruments _instruments;

  instrumentcard(this._instruments);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        color: ColorsTheme.darkred.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_instruments.exchange),
        ),
      ),
      title: Text(_instruments.tradingsymbol.toString()),
      subtitle: Text(_instruments.name.toString()),
    );
  }
}
