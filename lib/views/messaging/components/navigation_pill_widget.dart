import 'package:aulare/config/default_theme.dart';
import 'package:flutter/material.dart';

class NavigationPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
          Container(
              child: Center(
                  child: Wrap(children: <Widget>[
            Container(
                width: 50,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 5,
                decoration: BoxDecoration(
                  color: darkTheme.colorScheme.secondary,
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                )),
          ]))),
        ]));
  }
}
