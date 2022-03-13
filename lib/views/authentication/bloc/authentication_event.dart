part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent([List props = const <dynamic>[]]);

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class AppLaunched extends AuthenticationEvent {
  @override
  String toString() => 'AppLaunched';
}

class Login extends AuthenticationEvent {
  const Login({
    required this.username,
    required this.password,
  });

  // final String token;
  final String username;
  final String password;

  @override
  String toString() => 'Login { username: $username, password: $password }';
}

class Register extends AuthenticationEvent {
  const Register({
    required this.username,
    required this.password,
  });

  // final String token;
  final String username;
  final String password;

  @override
  String toString() => 'Register { username: $username, password: $password }';
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
  SaveProfile(
      // this.profilePicture,
      this.username)
      : super([
          // profilePicture,
          username
        ]);
  // final File profilePicture;
  final String username;

  @override
  String toString() => 'SaveProfile';
}

class Logout extends AuthenticationEvent {
  @override
  String toString() => 'Logout';
}

class UsernameInputActivated extends AuthenticationEvent {
  @override
  String toString() => 'UsernameInputActivated';
}

class PasswordInputActivated extends AuthenticationEvent {
  @override
  String toString() => 'PasswordInputActivated';
}
