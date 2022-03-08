import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/components/message_input.dart';
import 'package:aulare/views/messaging/components/message_list.dart';
import 'package:aulare/views/messaging/components/messages_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'models/conversation.dart';

class MessagingPage extends StatefulWidget {
  const MessagingPage(this.conversation);

  @override
  _MessagingPageState createState() => _MessagingPageState(conversation);

  final Conversation conversation;
}

class _MessagingPageState extends State<MessagingPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  //mixin lets class body be reused in multiple class hierarchies

  _MessagingPageState(this.conversation);

  final Conversation conversation;

  late MessagingBloc messagingBloc;

  @override
  void initState() {
    super.initState();

    messagingBloc = BlocProvider.of<MessagingBloc>(context);
    messagingBloc.add(FetchCurrentConversationDetails(conversation));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print('build of $conversation');
    // return Container(child: Center(child: Text(chat.username),),);
    return SafeArea(
      child: Scaffold(
        appBar: const MessagesAppBar(),
        body: Column(
          children: [
            MessageList(conversation),
            const Divider(height: 1),
            MessageInput(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
