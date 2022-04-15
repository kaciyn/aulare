import 'package:aulare/views/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/cupertino.dart';

abstract class AulareException implements Exception {
  String errorMessage();
}

class UserNotFoundException extends AulareException {
  @override
  String errorMessage() => 'No user found for provided uid/username';
}

class ContactInContactListNotInDb extends AulareException {
  @override
  String errorMessage() => 'Contact id was not found in db';
}

class ContactMappingException extends AulareException {
  ContactMappingException(this.exception);
  Object exception;
  @override
  String errorMessage() => 'ContactMappingException: ${exception.toString()}';
}

class ContactConversationNotCreated extends AulareException {
  ContactConversationNotCreated(this.contactUsername);

  final contactUsername;

  @override
  String errorMessage() =>
      "Conversation for contact: $contactUsername doesn't exist";
}

class UsernameMappingUndefinedException extends AulareException {
  @override
  String errorMessage() => 'User not found';
}

class ContactAlreadyExistsException extends AulareException {
  @override
  String errorMessage() => 'Contact already exists!';
}

class InvalidStateException extends AulareException {
  @override
  String errorMessage() => 'State is not Authenticated or Unauthenticated';
}

class ConversationContactNotFoundException extends AulareException {
  @override
  String errorMessage() =>
      'Conversation has no contact! Something has gone terribly wrong in the db because this literally cannot happen';
}

class MiscRegistrationException extends AulareException {
  @override
  String errorMessage() =>
      "Otherwise uncaught authentication exception happened. We just don't know";
}

//borrowed wholesale from the bloc tut
/// {@template sign_up_with_username_and_password_failure}
/// Thrown if during the sign up process if a failure occurs.
/// {@endtemplate}
class SignUpWithUsernameAndPasswordFailure implements Exception {
  /// {@macro sign_up_with_username_and_password_failure}
  const SignUpWithUsernameAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithusernameAndPassword.html
  factory SignUpWithUsernameAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-username':
        return const SignUpWithUsernameAndPasswordFailure(
          'username is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const SignUpWithUsernameAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'username-already-in-use':
        return const SignUpWithUsernameAndPasswordFailure(
          'An account already exists for that username.',
        );
      case 'operation-not-allowed':
        return const SignUpWithUsernameAndPasswordFailure(
          'Operation is not allowed.  Please contact support.',
        );
      case 'weak-password':
        return const SignUpWithUsernameAndPasswordFailure(
          'Please enter a stronger password.',
        );
      default:
        return const SignUpWithUsernameAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// {@template log_in_with_username_and_password_failure}
/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithusernameAndPassword.html
/// {@endtemplate}
class LogInWithusernameAndPasswordFailure implements Exception {
  /// {@macro log_in_with_username_and_password_failure}
  const LogInWithusernameAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithusernameAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-username':
        return const LogInWithusernameAndPasswordFailure(
          'username is not valid or badly formatted.',
        );
      case 'user-disabled':
        return const LogInWithusernameAndPasswordFailure(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const LogInWithusernameAndPasswordFailure(
          'username is not found, please create an account.',
        );
      case 'wrong-password':
        return const LogInWithusernameAndPasswordFailure(
          'Incorrect password, please try again.',
        );
      default:
        return const LogInWithusernameAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}
