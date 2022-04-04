import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/views/messaging/components/messaging_page_slide.dart';
import 'package:aulare/views/messaging/models/conversation_info.dart';
import 'package:aulare/views/messaging/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConversationRow extends StatelessWidget {
  const ConversationRow(this.conversationInfo);

  final ConversationInfo conversationInfo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          SlideLeftRoute(
              page: ConversationPageSlide(
                  startContact:
                      Contact.fromConversationInfo(conversationInfo)))),
      child: Container(
          padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.cyan,
                          radius: 10,
                          child: Text(conversationInfo.user.username[0]),
                        ),
                        // if (conversationInfo.user!.name!=null){
                        //                         child: Text(conversationInfo.user!.name[0]);}
                        // else{child: Text('U');}
                        // )),
                        // backgroundImage: Image.network(
                        //   conversationInfo.user!.profilePictureUrl!,
                        // ).image,
                        width: 61.0,
                        height: 61.0,
                        padding: const EdgeInsets.all(1.0),
                        // border width
                        decoration: BoxDecoration(
                          color:
                              darkTheme.colorScheme.secondary, // border color
                          shape: BoxShape.circle,
                        )),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          conversationInfo.user.username,
                          // style: Styles.subHeading
                        ),
                        messageContent(conversationInfo.latestMessage!)
                      ],
                    ))
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('kk:mm - dd-MM-yyyy')
                          .format(conversationInfo.latestMessage!.timestamp!
                              .toLocal())
                          .toString(),
                      // style: Styles.date,
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  Row messageContent(Message latestMessage) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          if (latestMessage.isFromSelf)
            Icon(
              Icons.done,
              size: 12,
              color: darkTheme.primaryColorDark,
            )
          else
            Container(),
          const SizedBox(
            width: 2,
          ),
          Text(
            latestMessage.text!,
            // style: Styles.subText,
          )
        ]);
  }
}
