part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class Uninitialized extends AuthenticationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticating extends AuthenticationState {
  @override
  String toString() => 'AuthInProgress';
}

class Authenticated extends AuthenticationState {
  Authenticated(this.user);

  final firebase.User user;

  @override
  String toString() => 'Authenticated';
}

class PreFillData extends AuthenticationState {
  PreFillData(this.user);

  final User user;

  @override
  String toString() => 'PreFillData';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'UnAuthenticated';
}

class ReceivedProfilePicture extends AuthenticationState {
  final File file;

  ReceivedProfilePicture(this.file);

  @override
  String toString() => 'ReceivedProfilePicture';
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState {
  @override
  String toString() => 'ProfileComplete';
}
