import 'package:aulare/config/default_theme.dart';
import 'package:flutter/material.dart';

mixin Decorations {
  static InputDecoration getInputDecoration(
      {required String hint, required BuildContext context}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).hintColor),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.1),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).hintColor, width: 0.1),
      ),
    );
  }

  static InputDecoration getInputDecorationLight(
      {required String hint, required BuildContext context}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).hintColor),
      contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkTheme.primaryColor, width: 0.1),
      ),
    );
  }
}
