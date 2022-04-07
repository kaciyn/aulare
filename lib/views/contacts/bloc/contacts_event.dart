part of 'contacts_bloc.dart';

@immutable
abstract class ContactsEvent extends Equatable {
  const ContactsEvent({this.contacts, this.contact});

  final List<Contact>? contacts;
  final Contact? contact;

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

// class ContactUsernameInputActivated extends ContactsEvent {
//   @override
//   String toString() => 'ContactUsernameInputActivated';
// }

class ContactUsernameChanged extends ContactsEvent {
  const ContactUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

// Fetch the contacts from firebase
class FetchContacts extends ContactsEvent {
  @override
  String toString() => 'FetchContacts';
}

// Fetch the contacts from firebase
// class FetchContactsList extends ContactsEvent {
//   @override
//   String toString() => 'FetchContactsList';
// }

// Dispatch received contacts from stream
class ReceiveContacts extends ContactsEvent {
  const ReceiveContacts(this.contacts);

  @override
  final List<Contact> contacts;

  @override
  List<Object> get props => [contacts];

  @override
  String toString() => 'ReceiveContacts';
}

//Add a new contact
class AddContact extends ContactsEvent {
  const AddContact();

  @override
  String toString() => 'AddContact';
}

// CLicked a contact
class ClickedContact extends ContactsEvent {
  const ClickedContact({required this.contact}) : super(contact: contact);
  @override
  final Contact contact;

  @override
  String toString() => 'ClickedContact';
}
