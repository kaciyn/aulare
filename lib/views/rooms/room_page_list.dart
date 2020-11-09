import 'file:///D:/BigBadCodeRepos/aulare/lib/config/defaultTheme.dart';
import 'file:///D:/BigBadCodeRepos/aulare/lib/views/messages/components/message_list.dart';
import 'package:flutter/material.dart';

import '../messages/bloc/messaging_page.dart';

class RoomPageList extends StatefulWidget {
  @override
  _RoomPageListState createState() => _RoomPageListState();
}

class _RoomPageListState extends State<RoomPageList> {
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
