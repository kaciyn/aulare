import 'package:aulare/views/conversations/conversation_list_page.dart';
import 'package:aulare/views/messaging/components/navigation_pill_widget.dart';
import 'package:flutter/material.dart';

class ConversationBottomSheet extends StatefulWidget {
  const ConversationBottomSheet();

  @override
  _ConversationBottomSheetState createState() =>
      _ConversationBottomSheetState();
}

class _ConversationBottomSheetState extends State<ConversationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(children: <Widget>[
              GestureDetector(
                child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    children: <Widget>[
                      NavigationPill(),
                      const Center(
                          child: Text(
                        'Messages',
                        // style: Styles.textHeading
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                    ]),
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity > 50) {
                    Navigator.pop(context);
                  }
                },
              ),
              ConversationListPage(),
            ])));
  }
}
