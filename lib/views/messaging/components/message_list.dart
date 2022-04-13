// ignore_for_file: avoid_print

import 'package:aulare/views/messaging/bloc/messaging_bloc.dart';
import 'package:aulare/views/messaging/components/message_row.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/conversation.dart';

class MessageList extends StatelessWidget {
  MessageList({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  final ScrollController listScrollController = ScrollController();

  List<Message>? messages = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessagingBloc, MessagingState>(
        builder: (context, state) {
      print(state);
      if (state is Initial) {
        context
            .read<MessagingBloc>()
            .add(FetchCurrentConversationDetails(conversation));
        listScrollController.addListener(() {
          final maxScroll = listScrollController.position.maxScrollExtent;
          final currentScroll = listScrollController.position.pixels;
          if (maxScroll == currentScroll) {
            context
                .read<MessagingBloc>()
                .add(FetchOlderMessages(conversation, messages!.last));
          }
        });
      }
      if (state is MessagesFetched) {
        print('Received Messages');
        if (state.contactUsername == conversation.contact.username) {
          print(state.messages!.length);
          print(state.isPrevious);
          if (state.isPrevious) {
            messages!.addAll(state.messages!);
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
        itemBuilder: (context, int index) => MessageRow(messages![index]),
        reverse: true,
        itemCount: messages!.length,
        controller: listScrollController,
      ));
    });
  }
}
