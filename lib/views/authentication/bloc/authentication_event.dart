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
  @override
  String toString() => 'ClickedLogIn';
  // String toString() => 'LogIn { token: $token }';
}

class Login extends AuthenticationEvent {
  Login({
    @required this.username,
    @required this.password,
  });

  // final String token;
  final String username;
  final String password;

  @override
  String toString() =>
      'ClickedLogIn { username: $username, password: $password }';
}

class ClickedRegister extends AuthenticationEvent {
  @override
  String toString() => 'ClickedRegister';
}

class LoggedIn extends AuthenticationEvent {
  LoggedIn(this.user) : super([user]);
  final firebase.User user;

  @override
  String toString() => 'LoggedIn';
}

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
