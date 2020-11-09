import 'package:aulare/views/conversations/models/conversation.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/widgets/message_input.dart';
import 'package:aulare/views/messaging/widgets/message_list.dart';
import 'package:aulare/views/messaging/widgets/messages_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage(this.conversation);

  @override
  _MessagingPageState createState() => _MessagingPageState(conversation);

  final Conversation conversation;
}

class _MessagingPageState extends State<MessagingPage>
    with TickerProviderStateMixin {
  //mixin lets class body be reused in multiple class hierarchies

  _MessagingPageState(this.conversation);

  final Conversation conversation;

  MessagingBloc messagingBloc;

  @override
  void initState() {
    messagingBloc = BlocProvider.of<MessagingBloc>(context);
    messagingBloc.add(FetchCurrentConversationDetails(conversation));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const MessagesAppBar(),
        body: Column(
          children: [
            MessageList(),
            const Divider(height: 1),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
