import 'package:flutter/material.dart';

class MessagesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MessagesAppBar({
    Key? key,
  }) : super(key: key);

  final double height = 50;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('AULARE'),
      actions: [
        IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
      ], //nav will go in here, want it to be different in the different screens
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  void _pushSaved() {
    // Navigator.of(context).push(MaterialPageRoute<void>(
    //   //HOW DO PASS CONTEXT HERE
    //   // NEW lines from here...
    //   builder: (BuildContext context) {
    //     return Text('this is a page');
    //   },
    // )); do this with the new navigation
  }
}
