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
    // required this.contact,
  }) : super(key: key);

  final Conversation conversation;

  // final Contact contact;

  @override
  Widget build(context) {
    // final Conversation conversation =
    //     Conversation(contact.username, contact.conversationId);
    // super.build(context);
    // print('build of $conversation');
    // return Container(child: Center(child: Text(chat.username),),);
    return
        // BlocListener<MessagingBloc, MessagingState>(
        // listener: (context, state) {
        //   if (state is Initial) {
        //     context
        //         .read<MessagingBloc>()
        //         .add(FetchCurrentConversationDetails(conversation));
        //   }
        // },
        // child:
        SafeArea(
            child: Scaffold(
      // appBar: const MessagesAppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            MessageList(conversation: conversation),
            const Divider(height: 1),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(height: 50, child: MessageInput(conversation)),
            )
          ],
        ),
      ),
    ));
    //   );
  }
}
// class _MessagingPageState extends State<MessagingPage>
//     with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
//   //mixin lets class body be reused in multiple class hierarchies
//
//   _MessagingPageState(this.conversation);
//
//   final Conversation conversation;
//
//   late MessagingBloc messagingBloc;
//
//   @override
//   void initState() {
//     super.initState();
//
//     messagingBloc = BlocProvider.of<MessagingBloc>(context);
//     messagingBloc.add(FetchCurrentConversationDetails(conversation));
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
