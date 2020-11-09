import 'package:aulare/views/conversations/components/room.dart';
import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messaging/bloc/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageList extends StatefulWidget {
  final Conversation conversation;

  MessageList(this.conversation);

  @override
  _MessageListState createState() => _MessageListState(conversation);

  // const MessageList({
  //   Key key,
  //   @required List messages,
  // })  : _messages = messages,
  //       super(key: key);
  //
  // final List _messages;
  //
  // @override
  // Widget build(BuildContext context) {
  //   return Flexible(
  //       //message list
  //       child: ListView.builder(
  //     itemBuilder: (_, int index) => _messages[index],
  //     reverse: true,
  //     itemCount: _messages.length,
  //   ));
  // }
}

class _MessageListState extends State<MessageList> {
  final ScrollController listScrollController = ScrollController();
  List<Message> messages = [];
  final Conversation conversation;

  _MessageListState(this.conversation);

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      var maxScroll = listScrollController.position.maxScrollExtent;
      var currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        BlocProvider.of<MessageBloc>(context)
            .dispatch(FetchPreviousMessagesEvent(this.conversation,messages.last));
      }
    });
  }
