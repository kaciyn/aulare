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
  String toString() => 'Authenticating';
}

// class Authenticated extends AuthenticationState {
//   Authenticated(this.displayName) : super([displayName]);
//   final String displayName;
//
//   @override
//   String toString() => 'Authenticated';
// }

class Authenticated extends AuthenticationState {
  Authenticated(this.user);

  final firebase.User user;

  @override
  String toString() => 'Authenticated';
}

class Unauthenticated extends AuthenticationState {
  @override
  String toString() => 'Unauthenticated';
}

class DataPrefilled extends AuthenticationState {
  const DataPrefilled(this.user);

  final User user;

  @override
  String toString() => 'DataPrefilled';
}

class ProfilePictureReceived extends AuthenticationState {
  const ProfilePictureReceived(this.file);

  final File file;

  @override
  String toString() => 'ProfilePictureReceived';
}

class ProfileUpdateInProgress extends AuthenticationState {
  @override
  String toString() => 'ProfileUpdateInProgress';
}

class ProfileUpdated extends AuthenticationState {
  @override
  String toString() => 'ProfileComplete';
}

class Failed extends AuthenticationState {
  const Failed({@required this.error});

  final String error;

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'Login Failed { error: $error }';
}
