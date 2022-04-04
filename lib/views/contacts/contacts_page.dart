import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_list.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ContactsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
