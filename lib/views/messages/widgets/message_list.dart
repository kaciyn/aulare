import 'package:flutter/material.dart';

class MessageList extends StatelessWidget {
  const MessageList({
    Key key,
    @required List messages,
  })  : _messages = messages,
        super(key: key);

  final List _messages;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor),
      child: ListView.builder(
        itemBuilder: (_, int index) => _messages[index],
        reverse: true,
        itemCount: _messages.length,
      ),
    );
  }
}
