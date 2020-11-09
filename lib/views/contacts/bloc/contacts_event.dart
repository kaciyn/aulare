part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  ContactsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];
}

// Fetch the contacts from firebase
class FetchContactsEvent extends ContactsEvent {
  @override
  String toString() => 'FetchContactsEvent';
}

// Dispatch received contacts from stream
class ReceivedContactsEvent extends ContactsEvent {
  ReceivedContactsEvent(this.contacts) : super([contacts]);
  final List<Contact> contacts;

  @override
  String toString() => 'ReceivedContactsEvent';
}

//Add a new contact
class AddContactEvent extends ContactsEvent {
  AddContactEvent({@required this.username}) : super([username]);
  final String username;

  @override
  String toString() => 'AddContactEvent';
}

// CLicked a contact
class ClickedContactEvent extends ContactsEvent {
  @override
  String toString() => 'ClickedContactEvent';
}
