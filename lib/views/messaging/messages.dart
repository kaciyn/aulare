import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/components/message_input.dart';
import 'package:aulare/views/messaging/components/message_list.dart';
import 'package:aulare/views/messaging/components/messages_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/contact.dart';
import 'models/conversation.dart';

class Messages extends StatelessWidget {
  const Messages({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        child: Stack(
          children: [
            MessageList(conversation: conversation),
            const Divider(height: 1),
            Align(
                alignment: Alignment.bottomCenter,
                child: MessageInput(conversation)),
            // )
          ],
        ),
      ),
    ));
    //   );
  }
}
