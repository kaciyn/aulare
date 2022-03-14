// ignore: must_be_immutable
import 'package:aulare/config/default_theme.dart';
import 'package:flutter/material.dart';

class PageIndicatorDot extends StatefulWidget {
  PageIndicatorDot(this.isActive);

  bool isActive;

  @override
  _PageIndicatorDotState createState() => _PageIndicatorDotState();
}

class _PageIndicatorDotState extends State<PageIndicatorDot> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: widget.isActive
              ? darkTheme.primaryColor
              : darkTheme.colorScheme.secondary,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
