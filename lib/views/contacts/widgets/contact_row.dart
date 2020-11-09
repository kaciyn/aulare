import 'package:aulare/config/defaultTheme.dart';
import 'package:aulare/models/contact.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactRow extends StatelessWidget {
  const ContactRow({
    Key key,
    @required this.contact,
  }) : super(key: key);
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()
    =>
        BlocProvider.of<ContactsBloc>(context).add(ClickedContact(contact))
    ,
    child:Container(
    color: darkTheme.backgroundColor,
    child: Padding(
    padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
    child: RichText(
    text: TextSpan(
    style: Theme.of(context).textTheme.bodyText1,
    text: contact.getName(),
    ),
    )));
    }
}
