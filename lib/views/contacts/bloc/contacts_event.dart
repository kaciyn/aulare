part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  const ContactsEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

// Fetch the contacts from firebase
class FetchContacts extends ContactsEvent {
  @override
  String toString() => 'FetchContacts';
}

// Dispatch received contacts from stream
class ReceiveContacts extends ContactsEvent {
  ReceiveContacts(this.contacts) : super([contacts]);
  final List<Contact> contacts;

  @override
  String toString() => 'ReceiveContacts';
}

//Add a new contact
class AddContact extends ContactsEvent {
  AddContact({@required this.username}) : super([username]);
  final String username;

  @override
  String toString() => 'AddContact';
}

// CLicked a contact
class ClickedContact extends ContactsEvent {
  ClickedContact({@required this.contact}) : super([contact]);
  final Contact contact;

  @override
  String toString() => 'ClickedContact';
}
