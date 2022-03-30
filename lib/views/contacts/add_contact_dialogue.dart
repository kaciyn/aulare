import 'package:aulare/views/contacts/bloc/contacts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../components/modal_bottom_sheet_layout.dart';
import '../../config/default_theme.dart';

Future<void> showAddContactBottomSheet(context) async {
  await showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<ContactsBloc, ContactsState>(
            builder: (context, state) {
          return Container(
            color: darkTheme.scaffoldBackgroundColor,
            // Color(0xFF737373),
            // This line set the transparent background
            child: Container(
                decoration: BoxDecoration(
                    color: darkTheme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0))),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Padding(
                      //     padding: const EdgeInsets.only(left: 20, right: 20),
                      // child: Image.asset(Assets.social)),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: const Text(
                          'ADD CONTACT BY USERNAME',
                          // style: Styles.textHeading,
                        ),
                      ),
                      const ContactUsernameInput(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          AddContactButton(),
                        ],
                      )
                    ],
                  ),
                )),
          );
        });
      });
}
//
// class ContactUsernameInput extends StatelessWidget {
//   const ContactUsernameInput({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ContactsBloc, ContactsState>(
//         buildWhen: (previous, current) => previous.username != current.username,
//         builder: (context, state) {
//           return Container(
//               margin: const EdgeInsets.fromLTRB(50, 20, 50, 20),
//               child: TextField(
//                 //TODO ADD HINT HERE SAYING SOMETHING ABOUT VERIFYING THE PERSON YOU'RE ADDING IS WHO THEY SAY THEY ARE - IDEALLY IN PERSON VERIFICATION
//                 // onTap: () =>
//                 //     context.read<ContactsBloc>().add(ContactUsernameInputActivated()),
//                 onChanged: (username) => context
//                     .read<ContactsBloc>()
//                     .add(ContactUsernameChanged(username)),
//                 // controller: usernameInputController,
//                 textAlign: TextAlign.center,
//                 // style: Styles.subHeading,
//                 decoration: InputDecoration(
//                   labelText: '@USERNAME',
//                   labelStyle: const TextStyle(color: Color(0xffadadad)),
//                   errorText: state.username.invalid ? 'invalid username' : null,
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide:
//                         BorderSide(color: darkTheme.colorScheme.secondary),
//                   ),
//                 ),
//               ));
//         });
//   }
// }

class ContactUsernameInput extends StatelessWidget {
  const ContactUsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
            key: const Key('addContactForm_usernameInput_textField'),
            //TODO ADD HINT HERE SAYING SOMETHING ABOUT VERIFYING THE PERSON YOU'RE ADDING IS WHO THEY SAY THEY ARE - IDEALLY IN PERSON VERIFICATION
            // onTap: () => context
            //     .read<ContactsBloc>()
            //     .add(ContactUsernameInputActivated()),
            onChanged: (username) => context
                .read<ContactsBloc>()
                .add(ContactUsernameChanged(username)),
            cursorColor: darkTheme.colorScheme.secondary,
            decoration: InputDecoration(
              labelText: 'ENTER CONTACT USERNAME',
              labelStyle: const TextStyle(color: Color(0xffadadad)),
              errorText: state.username.invalid ? 'invalid username' : null,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: darkTheme.colorScheme.secondary),
              ),
            ));
      },
    );
  }
}

class AddContactButton extends StatelessWidget {
  const AddContactButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SizedBox(
                width: 200,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 30, right: 10, left: 10),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: darkTheme.colorScheme.secondary)),
                  child: state.status.isSubmissionInProgress
                      ? const ProgressIndicator()
                      // ? const CircularProgressIndicator()
                      : TextButton(
                          key: const Key('loginForm_continue_Button'),
                          onPressed: state.status.isValidated
                              ? () => {
                                    context
                                        .read<ContactsBloc>()
                                        .add(const AddContact())
                                  }
                              : null,
                          child: Text('ADD CONTACT',
                              style: TextStyle(
                                  color: darkTheme.colorScheme.secondary,
                                  fontWeight: FontWeight.w800))),
                ),
              );
      },
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
      return Container(
        child: state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : null,
      );
    });
  }
}

// class AddContactButton extends StatelessWidget {
//   const AddContactButton({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ContactsBloc, ContactsState>(builder: (context, state) {
//       return FloatingAddButton(
//         elevation: 0.0,
//         child: getButtonChild(state),
//         onPressed: state.status.isValidated
//             ? () {
//                 context.read<ContactsBloc>().add(const AddContact());
//               }
//             : null,
//       );
//     });
//   }
// }

Widget getButtonChild(ContactsState state) {
  if (state is ContactSuccessfullyAdded || state is Error) {
    return Icon(Icons.check, color: darkTheme.primaryColor);
  } else if (state is AddingContact) {
    return const SizedBox(
      height: 9,
      width: 9,
      child: CircularProgressIndicator(
        value: null,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  } else {
    return Icon(Icons.done, color: darkTheme.primaryColor);
  }
}
