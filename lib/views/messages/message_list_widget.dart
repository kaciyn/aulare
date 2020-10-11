import 'package:flutter/material.dart';

class MessageListWidget extends StatelessWidget {
  const MessageListWidget({
    Key key,
    @required List messages,
  })  : _messages = messages,
        super(key: key);

  final List _messages;

  @override
  Widget build(BuildContext context) {
    return Flexible(
        //message list
        child: ListView.builder(
      itemBuilder: (_, int index) => _messages[index],
      reverse: true,
      itemCount: _messages.length,
    ));
  }
}
