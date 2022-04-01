import 'dart:async';

import 'package:aulare/models/contact.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/constants.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/utilities/shared_objects.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

import '../../../models/username.dart';

part 'contacts_event.dart';

part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  late UserDataRepository userDataRepository;
  late MessagingRepository messagingRepository;
  late StreamSubscription subscription;

  ContactsBloc(
      {required UserDataRepository userDataRepository,
      required MessagingRepository messagingRepository})
      : super(Initial()) {
    on<FetchContacts>((event, emit) async {
      try {
        emit(FetchingContacts().copyWith(
            username: state.username,
            status: Formz.validate([state.username])));

        // await subscription?.cancel();

        subscription = userDataRepository.getContacts().listen((contacts) =>
            {print('adding $contacts'), add(ReceiveContacts(contacts))});
      } on AulareException catch (exception) {
        print(exception.errorMessage());
        emit(Error(exception));
      }
    });

    on<ContactUsernameChanged>((event, emit) {
      final username = Username.dirty(event.username);

      emit(state.copyWith(
        username: username,
        status: Formz.validate([username]),
      ));
    });
    // on<ContactUsernameInputActivated>((event, emit) async {
    //   emit(const UsernameInputActive().copyWith(
    //       username: state.username, status: Formz.validate([state.username])));
    // });
    //
    // on<ContactUsernameChanged>((event, emit) {
    //   final username = Username.dirty(event.username);
    //   print('1 USERNAME IS: ${state.username.value}');
    //   print('2 USERNAME IS: ${username}');
    //
    //   emit(const UsernameInputActive().copyWith(
    //     username: username,
    //     status: Formz.validate([username]),
    //   ));
    //   print('value USERNAME IS: ${state.username.value}');
    //   print('tostring USERNAME  IS: ${state.username.toString()}');
    //   print('4 USERNAME IS: ${username}');
    // });

    on<ReceiveContacts>((event, emit) {
      print('Received');
      emit(FetchingContacts());

      emit(ContactsFetched(event.contacts));
    });

    on<AddContact>((event, emit) async {
      if (state.username.value ==
          SharedObjects.preferences.getString(Constants.sessionUsername)) {
        print("YOU CAN'T ADD YOURSELF AS A CONTACT");
        return;
      }

      emit(FetchingContacts()
          .copyWith(username: state.username, status: state.status));

      var contactUsername = state.username;
      if (state.status.isValidated) {
        emit(AddingContact().copyWith(
            username: contactUsername,
            status: FormzStatus.submissionInProgress));

        try {
          await userDataRepository.addContact(username: contactUsername.value);
        } catch (_) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
          // print(exception.errorMessage());
          // emit(AddContactFailed(exception));
        }
        // t ry {
        final contact =
            await userDataRepository.getUser(username: contactUsername.value);
        await messagingRepository.createConversationIdForContact(contact);
        // } catch (_) {
        //   print('ERROR CREATING CONVERSATION ID FOR NEW CONTACT');
        // }

        add(FetchContacts());
        emit(ContactSuccessfullyAdded()
            .copyWith(status: FormzStatus.submissionSuccess));
      }
    });

    // on<ClickedContact>((event, emit) {
//TODO: Redirect to chat screen
//     });
  }

  @override
  Future<void> close() async {
    subscription.cancel();
    super.close();
  }
}
