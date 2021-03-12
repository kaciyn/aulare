// ignore: must_be_immutable
import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

class CircleIndicator extends StatefulWidget {
  CircleIndicator(this.isActive);

  bool isActive;

  @override
  _CircleIndicatorState createState() => _CircleIndicatorState();
}

class _CircleIndicatorState extends State<CircleIndicator> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: widget.isActive ? 12 : 8,
      width: widget.isActive ? 12 : 8,
      decoration: BoxDecoration(
          color:
              widget.isActive ? darkTheme.primaryColor : darkTheme.accentColor,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
