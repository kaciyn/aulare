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
  }) : super(key: key);

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        // onWillPop: () async {
        //   Navigator.pushNamed(context, '/home');
        //   return true;
        //   // }
        // },
        // child:
        Scaffold(
      appBar: AppBar(
        title: Text(conversation.contact.username),
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
        ),
        // )
      ),
    );
  }
}
