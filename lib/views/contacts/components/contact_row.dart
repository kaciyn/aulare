import 'package:aulare/config/default_theme.dart';
import 'package:aulare/config/transitions.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/messaging/messaging_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../messaging/models/conversation.dart';

class ContactRow extends StatelessWidget {
  const ContactRow({
    Key? key,
    required this.contact,
  }) : super(key: key);
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(
            context,
            SlideLeftRoute(
                page: MessagingPage(
              conversation: Conversation.withoutLatestMessage(
                  contact.conversationId, contact),
              // contact: contact,
            ))),
        child: AbsorbPointer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  color: darkTheme.scaffoldBackgroundColor,
                  child: Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyText1,
                          text: contact.getUsername(),
                        ),
                      ))),
              const Divider(
                height: 1,
                color: Colors.black,
              )
            ],
          ),
        ));
  }
}
