import 'file:///D:/BigBadCodeRepos/aulare/lib/config/defaultTheme.dart';
import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messages/components/message_list.dart';
import 'package:flutter/material.dart';

import '../messages/bloc/messaging_page.dart';

class ConversationListPage extends StatefulWidget {
  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
        // Expanded(flex: 2, child: ChatAppBar()), // Custom app bar for chat screen
        Expanded(
        flex: 11,
        child: Container(
          color: darkTheme.backgroundColor,
          child: MessageList(),
        ))
    // return PageView(
    //   children: <Widget>[
    //     RoomPage(),
    //     RoomPage(),
    //     RoomPage()
    //   ],
    // );
  }
}
