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
      : super(Initial()) {
    on<FetchContacts>(_onFetchContacts);
    on<ReceiveContacts>(_onReceiveContacts);
    on<AddContact>(_onAddContact);
    on<ClickedContact>(_onClickedContact);
  }

  UserDataRepository userDataRepository;
  MessagingRepository messagingRepository;
  StreamSubscription subscription;

  Future<void> _onFetchContacts(event, emit) async {
    try {
      emit(FetchingContacts());

      await subscription.cancel();
      subscription = userDataRepository.getContacts().listen((contacts) =>
          {print('adding $contacts'), add(ReceiveContacts(contacts))});
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      emit(Error(exception));
    }
  }

  void _onReceiveContacts(event, emit) {
    print('Received');
    // emit(FetchingContactsState());

    emit(ContactsFetched(event.contacts));
  }

  Future<void> _onAddContact(event, emit) async {
    // emit(FetchingContactsState());
    // emit * (mapAddContactEventToState(event.username));
    try {
      emit(AddingContact());

      await userDataRepository.addContact(event.username);
      final user = await userDataRepository.getUser(event.username);
      await messagingRepository.createConversationIdForContact(user);

      emit(ContactSuccessfullyAdded());
      add(FetchContacts());
    } on AulareException catch (exception) {
      print(exception.errorMessage());
      emit(AddContactFailed(exception));
    }
  }

  void _onClickedContact(event, emit) {
    //TODO: Redirect to chat screen
  }

  @override
  Future<void> close() async {
    subscription.cancel();
    super.close();
  }
}
