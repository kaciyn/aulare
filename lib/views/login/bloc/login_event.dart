part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List get props => <dynamic>[];

  @override
  bool get stringify => true;
}

class UsernameInputActivated extends LoginEvent {
  @override
  String toString() => 'UsernameInputActivated';
}

class PasswordInputActivated extends LoginEvent {
  @override
  String toString() => 'PasswordInputActivated';
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
