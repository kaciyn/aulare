part of 'contacts_bloc.dart';

class ContactsState extends Equatable {
  ContactsState(
      {this.status = FormzStatus.pure,
      this.username = const Username.pure(),
      this.errorMessage,
      this.contacts,
      this.exception});

  final FormzStatus status;
  final Username username;
  final String? errorMessage;
  final AulareException? exception;
  List<Contact>? contacts;

  ContactsState copyWith(
      {FormzStatus? status,
      Username? username,
      List<Contact>? contacts,
      String? errorMessage,
      AulareException? exception}) {
    return ContactsState(
      status: status ?? this.status,
      username: username ?? this.username,
      contacts: contacts ?? this.contacts,
      errorMessage: errorMessage ?? this.errorMessage,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object> get props => [status, username];

  @override
  String toString() => 'ContactsState';
}

class Initial extends ContactsState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Initial';
}

// class ContactUsernameInputActive extends ContactsState {
//   const ContactUsernameInputActive({
//     this.status = FormzStatus.pure,
//     this.username = const Username.pure(),
//     this.errorMessage,
//   });
//
//   final FormzStatus status;
//   final Username username;
//   final String? errorMessage;
//
//   @override
//   UsernameInputActive copyWith({
//     FormzStatus? status,
//     Username? username,
//     String? errorMessage,
//   }) {
//     return UsernameInputActive(
//       status: status ?? this.status,
//       username: username ?? this.username,
//       errorMessage: errorMessage ?? this.errorMessage,
//     );
//     // @override
//     // String toString() => 'UsernameInputActive';
//   }
// }

//Fetching contacts from firebase
class FetchingContacts extends ContactsState {
  @override
  String toString() => 'FetchingContactsState';
}

//contacts fetched successfully
class ContactsFetched extends ContactsState {
  ContactsFetched(this.contacts) : super(contacts: contacts);
  final List<Contact>? contacts;

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
  AddContactFailed(this.exception) : super(exception: exception);
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
  Error(this.exception) : super(exception: exception);
  final AulareException exception;

  @override
  String toString() => 'ErrorState';
}
