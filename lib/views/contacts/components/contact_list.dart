import 'package:aulare/config/default_theme.dart';
import 'package:aulare/views/contacts/components/contact_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/contact.dart';
import '../bloc/contacts_bloc.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    Key? key,
    required this.scrollController,
    required this.nameList,
  }) : super(key: key);

  final ScrollController scrollController;
  final List nameList;

  @override
  Widget build(BuildContext context) {
    List<Contact>? contacts;

    return BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) {
          if (state is Initial) {
            contacts = [];
            // context.read<ContactsBloc>().add(FetchContacts());
            context.read<ContactsBloc>().add(FetchContactsList());
          }
        },
        child: CustomScrollView(controller: scrollController, slivers: <Widget>[
          SliverAppBar(
            backgroundColor: darkTheme.backgroundColor,
            expandedHeight: 180.0,
            pinned: true,
            elevation: 0,
            centerTitle: true,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                'CONTACTS',
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (contacts == null) {
                contacts = [];
                // context.read<ContactsBloc>().add(FetchContacts());
                context.read<ContactsBloc>().add(FetchContactsList());
              }
              return ContactRow(contact: contacts![index]);
            }, childCount: nameList.length),
          )
        ]));
  }
}
