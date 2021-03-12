part of 'contacts_bloc.dart';

abstract class ContactsState extends Equatable {
  const ContactsState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}

class Initial extends ContactsState {
  @override
  String toString() => 'Initial';
}

//Fetching contacts from firebase
class FetchingContacts extends ContactsState {
  @override
  String toString() => 'FetchingContactsState';
}

//contacts fetched successfully
class ContactsFetched extends ContactsState {
  ContactsFetched(this.contacts) : super([contacts]);
  final List<Contact> contacts;

  @override
  String toString() => 'ContactsFetchedState';
}

// Add Contact Clicked, show progressbar
class AddingContact extends ContactsState {
  @override
  String toString() => 'AddingContactState';
}

// Add contact success
class ContactSuccessfullyAdded extends ContactsState {
  @override
  String toString() => 'ContactSuccessfullyAdded';
}

// Add contact failed
class AddContactFailed extends ContactsState {
  AddContactFailed(this.exception) : super([exception]);
  final AulareException exception;

  @override
  String toString() => 'AddContactFailedState';
}

// Clicked a contact item
class ContactClicked extends ContactsState {
  @override
  String toString() => 'ContactClickedState';
}

class Error extends ContactsState {
  Error(this.exception) : super([exception]);
  final AulareException exception;

  @override
  String toString() => 'ErrorState';
}
