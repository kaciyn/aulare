import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'message.dart';
import '../components/message_input.dart';
import '../components/messages_app_bar.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({Key key}) : super(key: key);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<ConversationPage>
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
            // MessageList(),
            Divider(height: 1),
            MessageInput(),
            //i don't think i actually want this but saving it for other things perhaps
            //   GestureDetector(
            //       child:
            //       onPanUpdate: (DragUpdateDetails details) {
            // if (details.delta.dx < 0) {}
            // },
            // )
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   //dispose animation controllers when you don't need them anymore!
  //   for (Message message in _messages) {
  //     message.animationController.dispose();
  //     super.dispose();
  //   }
}
