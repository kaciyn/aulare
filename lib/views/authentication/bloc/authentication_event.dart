part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List props = const <dynamic>[]]);

  @override
  List<Object> get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class AppLaunched extends AuthenticationEvent {
  @override
  String toString() => 'AppLaunched';
}

class ClickedLogIn extends AuthenticationEvent {
  final String token;

  ClickedLogIn({@required this.token}) : super([token]);

  @override
  String toString() => 'LogIn { token: $token }';
}

class ClickedRegister extends AuthenticationEvent {
  @override
  String toString() => 'ClickedRegister';
}

class ClickedGoogleLogin extends AuthenticationEvent {
  @override
  String toString() => 'ClickedGoogleLogin';
}

class LoggedIn extends AuthenticationEvent {
  LoggedIn(this.token) : super([token]);
  final String token;

  @override
  String toString() => 'LoggedIn';
}

// class LoggedIn extends AuthenticationEvent {
//   LoggedIn(this.user) : super([user]);
//   final firebase.User user;
//
//   @override
//   String toString() => 'LoggedIn';
// }

class PickedProfilePicture extends AuthenticationEvent {
  PickedProfilePicture(this.file) : super([file]);
  final File file;

  @override
  String toString() => 'PickedProfilePicture';
}

class SaveProfile extends AuthenticationEvent {
  SaveProfile(this.profilePicture, this.username)
      : super([profilePicture, username]);
  final File profilePicture;
  final String username;

  @override
  String toString() => 'SaveProfile';
}

class Logout extends AuthenticationEvent {
  @override
  String toString() => 'Logout';
}
