import 'dart:async';

import 'package:aulare/models/contact.dart';
import 'package:aulare/repositories/user_data_repository.dart';
import 'package:aulare/utilities/exceptions.dart';
import 'package:aulare/views/messaging/bloc/messaging_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'contacts_event.dart';
part 'contacts_state.dart';

class ContactsBloc extends Bloc<ContactsEvent, ContactsState> {
  ContactsBloc(
      {UserDataRepository userDataRepository,
      MessagingRepository messagingRepository})
      : super(Initial());

  UserDataRepository userDataRepository;
  MessagingRepository messagingRepository;
  StreamSubscription subscription;

  @override
  Stream<ContactsState> mapEventToState(
    ContactsEvent event,
  ) async* {
    print(event);
    if (event is FetchContacts) {
      try {
        yield FetchingContacts();
        await subscription?.cancel();
        subscription = userDataRepository.getContacts().listen((contacts) =>
            {print('adding $contacts'), add(ReceiveContacts(contacts))});
      } on AulareException catch (exception) {
        print(exception.errorMessage());
        yield Error(exception);
      }
    }
    if (event is ReceiveContacts) {
      print('Received');
      //  yield FetchingContactsState();
      yield ContactsFetched(event.contacts);
    }
    if (event is AddContact) {
      yield* mapAddContactEventToState(event.username);
    }
    if (event is ClickedContact) {
      yield* mapClickedContactEventToState(event.contact);
    }
  }

  Stream<ContactsState> mapFetchContactsEventToState() async* {
    try {
      yield FetchingContacts();
      await subscription?.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) =>
          {print('dispatching $contacts'), add(ReceiveContacts(contacts))});
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      yield Error(exception);
    }
  }

  Stream<ContactsState> mapAddContactEventToState(String username) async* {
    try {
      yield AddingContact();
      await userDataRepository.addContact(username);
      final user = await userDataRepository.getUser(username);
      await messagingRepository.createConversationIdForContact(user);

      yield ContactSuccessfullyAdded();
      //dispatch(FetchContactsEvent());
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      yield AddContactFailed(exception);
    }
  }

  Stream<ContactsState> mapClickedContactEventToState(Contact contact) async* {
    //TODO: Redirect to chat screen
  }

  @override
  Future<void> close() {
    subscription.cancel();
    super.close();
  }
}
