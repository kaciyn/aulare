import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_list.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  static Page page() => MaterialPage<void>(child: ContactsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CONTACTS'),
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
          child: const ContactsList(),
        ));
  }
}
