import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

Expanded authenticationButton(
  String buttonLabel,
  Icon icon,
  Widget page,
  BuildContext context,
) {
  return Expanded(
    child: Container(
        margin: const EdgeInsets.only(top: 100, right: 10, left: 10),
        decoration:
            BoxDecoration(border: Border.all(color: darkTheme.accentColor)),
        child: FlatButton.icon(
            onPressed: () {
              navigateToPage(context, page);
            },
            color: Colors.transparent,
            icon: icon,
            label: Text(buttonLabel,
                style: const TextStyle(
                    // color: darkTheme.primaryTextColorLight,
                    fontWeight: FontWeight.w800)))),
  );
}

Future navigateToPage(BuildContext context, Widget page) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
