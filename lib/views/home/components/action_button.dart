import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({Key? key, this.onPressed, this.icon, this.label})
      : super(key: key);

  final VoidCallback? onPressed;
  final Widget? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            color: theme.colorScheme.secondary,
            elevation: 4.0,
            child: IconButton(
              onPressed: onPressed,
              icon: icon!,
              color: Colors.white,
              highlightColor: theme.colorScheme.primary,
            )),
      ),
      Text(label!),
    ]);
  }
}
