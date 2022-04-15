import 'dart:math';

import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/views/messaging/components/messaging_page_slide.dart';
import 'package:aulare/views/messaging/models/conversation.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../messaging/messaging_page.dart';

class ConversationRow extends StatelessWidget {
  const ConversationRow(this.conversation);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
              page: MessagingPage(
                  conversation: Conversation.withoutLatestMessage(
                      conversation.conversationId, conversation.contact)))),
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        // child: Row(
        //   children: <Widget>[
        //     Expanded(
        //       flex: 8,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              padding: const EdgeInsets.all(1.0),
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              // border width
              decoration: BoxDecoration(
                color: darkTheme.colorScheme.secondary, // border color
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                //todo this is just to differentiate users a bit better for now, would be persisted in db with user details
                backgroundColor:
                    Colors.accents[Random().nextInt(Colors.accents.length)],
                radius: 7,
                child: Text(conversation.contact.username[0]),
              ),
              // backgroundImage: Image.network(
              //   conversationInfo.user!.profilePictureUrl!,
              // ).image,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      conversation.contact.username,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    conversation.latestMessage!.text!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 10, color: Color(0xffadadad)),
                  )
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.topRight,
            //   child:
            Container(
              padding: EdgeInsets.fromLTRB(5, 0, 10, 15),
              child: Text(
                  DateFormat('HH:mm  dd-MM-yyyy')
                      .format(conversation.latestMessage!.timestamp.toLocal())
                      .toString(),
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xffadadad))),
            ),
            // )
          ],
        ),
      ),
      // Expanded(
      //   flex: 3,

      // )
      // ],
    );
    // ),
    // );
  }

  Widget messageContentWithCheck(Message latestMessage) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (latestMessage.isFromSelf)
            Icon(
              Icons.done,
              size: 12,
              color: darkTheme.secondaryHeaderColor,
            )
          else
            const SizedBox(
              width: 2,
            ),
          Text(
            latestMessage.text!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Color(0xffadadad)),
          )
        ]);
  }
}
