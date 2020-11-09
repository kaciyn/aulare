import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message_contents.dart';

class MessageRow extends StatelessWidget {
  MessageRow(this.message);

  final Message message;

  final AnimationController animationController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: null,
  );

  @override
  Widget build(BuildContext context) {
    final isFromSelf = message.isFromSelf;
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            const Divider(height: 0.5),
            buildMessageContainer(isFromSelf, message, context),
            // buildTimeStamp(context, isFromSelf, message),
          ],
        ),
      ),
    );
  }

  Row buildMessageContainer(
      bool isSelf, Message message, BuildContext context) {
    var lrEdgeInsets = 15.0;
    var tbEdgeInsets = 10.0;

    return Row(
      children: <Widget>[
        Container(
          child: MessageContents(message, context),
          padding: EdgeInsets.fromLTRB(
              lrEdgeInsets, tbEdgeInsets, lrEdgeInsets, tbEdgeInsets),
          constraints: BoxConstraints(maxWidth: 200.0),
          decoration: BoxDecoration(
              color: isSelf ? darkTheme.accentColor : darkTheme.canvasColor,
              borderRadius: BorderRadius.circular(8.0)),
          margin: EdgeInsets.only(
              right: isSelf ? 10.0 : 0, left: isSelf ? 0 : 10.0),
        )
      ],
      mainAxisAlignment: isSelf
          ? MainAxisAlignment.end
          : MainAxisAlignment.start, // aligns the chatitem to right end
    );
  }

  buildMessageContent(bool isSelf, Message message, BuildContext context) {
    return Text(
      message.text,
      style: TextStyle(
          color: isSelf ? darkTheme.accentColor : darkTheme.canvasColor),
    );
  }
  //
  // Row buildTimeStamp(BuildContext context, bool isSelf, Message message) {
  //   return Row(
  //       mainAxisAlignment:
  //           isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
  //       children: <Widget>[
  //         Container(
  //           child: Text(
  //             DateFormat('dd MMM kk:mm').format(
  //                 DateTime.fromMillisecondsSinceEpoch(message.timeStamp)),
  //             style: Theme.of(context).textTheme.caption,
  //           ),
  //           margin: EdgeInsets.only(
  //               left: isSelf ? 5.0 : 0.0,
  //               right: isSelf ? 0.0 : 5.0,
  //               top: 5.0,
  //               bottom: 5.0),
  //         )
  //       ]);
  // }
//rejig this later
// class MessageWidget extends StatelessWidget {
// const MessageWidget({
// Key key,
// @required this.message,
// }) : super(key: key);
//
// final Message message;
//
// @override
// Widget build(BuildContext context) {
// return Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// //gives highest position along y axis since it's in a row (the other axis)
// children: [
// const UserAvatar(),
// const MessageContentsWidget(message: message,
// // text: text, timestamp: timestamp
// ),
// ],
// );
// }
// @override
// void dispose() {
// //dispose animation controllers when you don't need them anymore!
// for (Message message in _messages) {
// message.animationController.dispose();
// super.dispose();
// }
// }

}
