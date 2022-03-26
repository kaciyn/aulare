import 'package:aulare/config/decorations.dart';
import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsernameInput extends StatelessWidget {
  const ContactUsernameInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
      child: TextField(
        //TODO ADD HINT HERE SAYING SOMETHING ABOUT VERIFYING THE PERSON YOU'RE ADDING IS WHO THEY SAY THEY ARE - IDEALLY IN PERSON VERIFICATION
        // onTap: () =>
        //     context.read<ContactsBloc>().add(UsernameInputActivated()),
        onChanged: (username) =>
            context.read<ContactsBloc>().add(ContactUsernameChanged(username)),
        // controller: usernameInputController,
        textAlign: TextAlign.center,
        // style: Styles.subHeading,
        decoration: Decorations.getInputDecoration(
          hint: 'ENTER CONTACT USERNAME',
          context: context,
        ),
      ),
    );
  }
}
