import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/contact.dart';
import 'messages.dart';
import 'models/conversation.dart';

class MessagingPage extends StatelessWidget {
  const MessagingPage({
    Key? key,
    required this.conversation,
    // required this.contact,
  }) : super(key: key);

  final Conversation conversation;
  // final Contact contact;

  // static Page page() =>  MaterialPage<void>(child: MessagingPage(conversation: conversation,));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(conversation.contactUsername ),
          backgroundColor: const Color(0xff0D0D0D),
          elevation: 0,
        ),
        body: BlocProvider(
          create: (context) {
            return ContactsBloc(
                userDataRepository:
                    RepositoryProvider.of<UserDataRepository>(context),
                messagingRepository:
                    RepositoryProvider.of<MessagingRepository>(context));
          },
          child: Messages(
            conversation: conversation,
            // contact: contact,
          ),
        ));
  }
}
