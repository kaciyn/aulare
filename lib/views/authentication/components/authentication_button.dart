import 'package:aulare/config/default_theme.dart';
import 'package:flutter/material.dart';

Expanded authenticationButton(
  String buttonLabel,
  Icon icon,
  // Widget page,
  String page,
  BuildContext context,
) {
  return Expanded(
    child: Container(
        margin: const EdgeInsets.only(top: 100, right: 10, left: 10),
        decoration: BoxDecoration(
            border: Border.all(color: darkTheme.colorScheme.secondary)),
        child: TextButton.icon(
            onPressed: () {
              navigateToPage(context, page);
            },
            // color: Colors.transparent,
            icon: icon,
            label: Text(buttonLabel,
                style: TextStyle(
                    color: darkTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w800)))),
  );
}

// Future navigateToPage(BuildContext context, Widget page) async {
//   await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => page),
//   );
// }
Future navigateToPage(BuildContext context, String page) async {
  await Navigator.pushNamed(context, page);
}
