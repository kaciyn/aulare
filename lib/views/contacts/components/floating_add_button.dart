import 'package:aulare/config/defaultTheme.dart';
import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({
    Key key,
    this.animation,
    this.vsync,
    this.elevation,
    @required this.child,
    @required this.onPressed,
  }) : super(key: key);

  final Animation<double> animation;
  final TickerProvider vsync;
  final VoidCallback onPressed;
  final Widget child;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final button = FloatingActionButton(
      elevation: elevation ?? 6,
      child: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomRight,
                colors: [darkTheme.backgroundColor, darkTheme.colorScheme.secondary])),
        child: child,
      ),
      onPressed: onPressed,
    );
    return animation != null
        ? AnimatedSize(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.linear,
            vsync: vsync,
            child: ScaleTransition(scale: animation, child: button))
        : button;
  }
}
