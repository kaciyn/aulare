import 'package:aulare/views/conversations/models/conversation.dart';
import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:aulare/views/messaging/widgets/message_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatefulWidget {
  MessageList(this.conversation);

  final Conversation conversation;

  @override
  _MessageListState createState() => _MessageListState(conversation);
}

class _MessageListState extends State<MessageList> {
  _MessageListState(this.conversation);

  final ScrollController listScrollController = ScrollController();

  List<Message> messages = [];
  final Conversation conversation;

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      final maxScroll = listScrollController.position.maxScrollExtent;
      final currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        BlocProvider.of<MessagingBloc>(context)
            .add(FetchMessages(this.conversation, messages.last));
      }
    });

    @override
    Widget build(BuildContext context) {
      return BlocBuilder<MessagingBloc, MessagingState>(
          builder: (context, state) {
            print(state);
            if (state is MessagesFetched) {
              print('Received Messages');
              if (state.username == conversation.user.username) {
                print(state.messages.length);
                print(state.isPrevious);
                if (state.isPrevious) {
                  messages.addAll(state.messages);
                } else {
                  messages = state.messages;
                }
              }
              messages = state.messages;
              print(state.messages);
            }
            return Flexible(
              //message list
                child: ListView.builder(
                  itemBuilder: (context, int index) =>
                      MessageRow(messages[index]),
                  reverse: true,
                  itemCount: messages.length,
                  controller: listScrollController,
                ));
          });
    }
  }
