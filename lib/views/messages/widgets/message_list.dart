import 'package:flutter/material.dart';
import 'package:honours/views/messages/widgets/message_widget.dart';

class MessageList extends StatelessWidget {
  // const MessageList({
  //   Key key,
  //   @required List messages,
  // })  : _messages = messages,
  //       super(key: key);

  final ScrollController listScrollController = new ScrollController();

  // final List _messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: ListView.builder(
        itemBuilder: (context, int index) => MessageWidget(index),
        reverse: true,
        itemCount: _messages.length,
        controller: listScrollController,
      ),
    );
  }
}
