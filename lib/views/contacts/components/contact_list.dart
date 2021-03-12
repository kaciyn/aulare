import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/views/contacts/components/contact_row.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({
    Key key,
    @required this.scrollController,
    @required this.nameList,
  }) : super(key: key);

  final ScrollController scrollController;
  final List nameList;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: scrollController, slivers: <Widget>[
      SliverAppBar(
        backgroundColor: darkTheme.backgroundColor,
        expandedHeight: 180.0,
        pinned: true,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text(
            "Contacts",
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return ContactRow(contact: nameList[index]);
        }, childCount: nameList.length),
      )
    ]);
  }
}
