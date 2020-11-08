import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_contents.dart';
import 'user_avatar.dart';

class Message extends StatelessWidget {
  Message({this.message, this.animationController});

  final AnimationController animationController = new AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this;

      @override
      Widget build(BuildContext context) {
  return SizeTransition(
  sizeFactor:
  CurvedAnimation(parent: animationController, curve: Curves.easeOut),
  axisAlignment: 0,
  child: Container(
  margin: EdgeInsets.symmetric(vertical: 10),
  child: Column(
  children: [
  Divider(height: 0.5),
  Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  //gives highest position along y axis since it's in a row (the other axis)
  children: [
  UserAvatar(),
  MessageContentsWidget(
  // text: text, timestamp: timestamp
  ),
  ],
  ),
  ],
  ),
  ),
  );
  }
}
