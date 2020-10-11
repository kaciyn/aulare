import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/message.dart';
import 'widgets/messages_app_bar.dart';
import 'widgets/message_composer.dart';
import 'widgets/message_list.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key key}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with TickerProviderStateMixin {
  //mixin lets class body be reused in multiple class hierarchies
  final List<Message> _messages = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MessagesAppBar(),
        body: Column(
          children: [
            MessageList(messages: _messages),
            Divider(height: 1),
            MessageComposer(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    //dispose animation controllers when you don't need them anymore!
    for (Message message in _messages) {
      message.animationController.dispose();
      super.dispose();
    }
  }
